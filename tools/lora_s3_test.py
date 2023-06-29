import sys
from dotenv import load_dotenv

from lora_s3 import *

load_dotenv(project_root / ".env")

S3_PREFIX = os.getenv("S3_PREFIX")
def delete_s3_objects(bucket_name, objects):
    # Construct the list of objects to delete
    delete_list = {'Objects': [{'Key': obj} for obj in objects]}

    # Delete the objects from the bucket
    response = get_s3_client().delete_objects(Bucket=bucket_name, Delete=delete_list)
    print(response)


def test_backup():
    delete_s3_objects(os.getenv("S3_BUCKET"), [
        S3_PREFIX+"lainsks.safetensors",
        S3_PREFIX+"lainkawaii.safetensors",
    ])
    sys.argv = ["s3.py",
                "backup",
                "--s3_bucket", os.getenv("S3_BUCKET"),
                "--s3_prefix",  S3_PREFIX,
                ]
    main()


def test_download():
    for file in [
        "lainsks.safetensors",
        "lainkawaii.safetensors"
    ]:
        f = project_root / "models/Lora" / file
        if os.path.exists(f):
            os.remove(f)
            print(f"Removed {file}")

    sys.argv = ["s3.py",
                "download",
                "--s3_bucket", os.getenv("S3_BUCKET"),
                "--s3_prefix", S3_PREFIX]
    main()


if __name__ == '__main__':
    test_download()
