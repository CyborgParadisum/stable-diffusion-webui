import os
from pathlib import Path
import argparse
import boto3
import requests
from botocore.client import BaseClient
from botocore.exceptions import ClientError
from colorama import Fore, Back, Style

# print(os.environ.get("AWS_ACCESS_KEY_ID"))
from tqdm import tqdm

project_root = Path(__file__).parent.parent
args: argparse.Namespace

s3: BaseClient

lora_dir = project_root / "models/Lora"
lora_txt = project_root / "configs/lora.txt"


def init():
    parse_args()
    global s3
    s3 = boto3.client('s3')


def get_s3_client():
    return s3


def parse_args():
    parser = argparse.ArgumentParser()
    # parser.add_argument('--backup', type=str)
    parser.add_argument('--s3_bucket', type=str)
    parser.add_argument('--s3_prefix', type=str)
    parser.add_argument('action', choices=['backup', 'download'])
    global args
    args = parser.parse_args()


def main():
    init()
    action = args.action
    match action:
        case 'backup':
            backup()
        case 'download':
            download()


def download():
    base_url = f"https://{args.s3_bucket}.s3.amazonaws.com/{args.s3_prefix}"
    download_one(base_url+"lora.txt", lora_txt)
    with open(lora_txt, "r") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            file_name = line.split("/")[-1]
            output = lora_dir / file_name
            if not os.path.exists(output):
                if base_url[-1] != "/":
                    base_url += "/"
                url = base_url + line
                # print(f'{str_yellow("download:")} {output} ... ', end='', flush=True)
                # urllib.request.urlretrieve(url, output, reporthook=show_progress)
                download_one(url, output)
                # print(str_yellow(' done'))
            else:
                print(str_green(f"already exists, skip: {output}"))


def download_one(url, output):
    print(str_yellow("form"), url)
    print(f'{str_yellow("download:")} {output} ... ')

    response = requests.get(url, stream=True)
    total_size_in_bytes = int(response.headers.get('content-length', 0))
    block_size = 1024  # 1 Kibibyte
    progress_bar = tqdm(total=total_size_in_bytes, unit='iB', unit_scale=True)

    with open(output, 'wb') as file:
        for data in response.iter_content(block_size):
            progress_bar.update(len(data))
            file.write(data)
    progress_bar.close()
    if total_size_in_bytes != 0 and progress_bar.n != total_size_in_bytes:
        print("ERROR, something went wrong")


def show_progress(block_num, block_size, total_size):
    progress = block_num * block_size / total_size
    tqdm.write(f"Downloading: {progress:.1%}")


def str_green(text):
    return Fore.GREEN + text + Style.RESET_ALL


def str_yellow(text):
    return Fore.YELLOW + text + Style.RESET_ALL


def str_red(text):
    return Fore.RED + text + Style.RESET_ALL


def set_file_permission(bucket_name, object_key):
    # Create a Boto3 S3 client
    try:
        # Grant 'READ' permission to 'Everyone'
        acl = 'public-read'
        s3.put_object_acl(Bucket=bucket_name, Key=object_key, ACL=acl)
        print(str_green("Permissions updated success:"), object_key)

        return True

    except Exception as e:
        print(str_red("Error setting file permission:"), object_key, e)
        return False


def upload(local_dir, file_name):
    # Construct the S3 key (object name)
    s3_key = os.path.join(args.s3_prefix, file_name)
    local_file = os.path.join(local_dir, file_name)
    upload_one(local_file, s3_key)

def upload_overwrite(local_file, s3_key):
    s3_bucket = args.s3_bucket
    print(f'{str_yellow("start upload:")} {s3_key} ... ', end='', flush=True)
    s3.upload_file(local_file, s3_bucket, s3_key)
    print(str_yellow(' done'))
    set_file_permission(s3_bucket, s3_key)

def upload_one(local_file, s3_key):
    s3_bucket = args.s3_bucket
    # Check if the file exists in S3
    try:
        s3.head_object(Bucket=s3_bucket, Key=s3_key)
        print(str_green("already exists in S3, skip:"), s3_key)
        set_file_permission(s3_bucket, s3_key)
    except ClientError as _:
        # File doesn't exist in S3, upload it
        upload_overwrite(local_file, s3_key)
        # Update the ACL (Access Control List) for the S3 object
    # set_file_permission(s3_bucket, s3_key)
    # s3.put_object_acl(Bucket=s3_bucket, Key=s3_key, ACL='public-read')
    # print(f'Permissions updated for {s3_key}')



def backup():
    # Specify the directory path
    directory = project_root / "models/Lora"
    # Get all file names in the directory
    file_names = os.listdir(directory)
    file_names = [file for file in file_names if file.endswith(".safetensors")]

    # Print the file names
    for file_name in file_names:
        upload(directory, file_name)

    with open(lora_txt, "w") as f:
        print(file_names)
        f.write("\n".join(file_names))
    s3_key = os.path.join(args.s3_prefix, "lora.txt")
    upload_overwrite(lora_txt, s3_key)
    print(str_green("lora.txt updated"))


if __name__ == '__main__':
    main()
