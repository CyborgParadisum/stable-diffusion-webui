# import subprocess
#
# # 获取 pip list 的输出
# output = subprocess.check_output(['pip', 'list']).decode('utf-8')
#
# # 读取 requirements.txt 文件
# with open('requirements.txt', 'r') as f:
#     requirements = f.readlines()
#
# # 筛选出 requirements.txt 中出现的包
# matching_packages = []
# for requirement in requirements:
#     package = requirement.strip()
#     if any(package.lower() in line.lower() for line in output.split('\n')):
#         matching_packages.append(package)
#
# # 输出带有版本号的要求格式
# # matching_requirements = [f"{package[0]}=={package[1]}" for package in
# matching_requirements=     [package.split("\\s") for package in matching_packages]
#
# # 打印匹配的要求格式
# for requirement in matching_requirements:
#     print(requirement)
import pathlib
from pprint import pprint
import pathlib
from pprint import pprint
from importlib.metadata import version, distributions
from importlib.resources import files
from pathlib import Path
from typing import List

project_path = Path(__file__).parent.parent
output = project_path / "requirements_linux_version.txt"

if output.exists():
    output.write_text("")


def get_installed_packages() -> dict:
    return {dist.metadata["Name"].lower(): dist.version for dist in distributions()}


def get_requirements_version(requirements_txt_path: Path) -> List[str]:
    installed_packages = get_installed_packages()
    requirements = []

    with open(requirements_txt_path) as requirements_txt:
        for line in requirements_txt:
            line = line.strip()
            if line and not line.startswith('#'):
                package_name = line.split('==')[0].lower()
                if package_name in installed_packages:
                    requirements.append(f"{package_name}=={installed_packages[package_name]}")
                else:
                    requirements.append("")

    return requirements


requirements = []
for req_file in ["requirements.txt", "requirements_linux.txt", "requirements_versions.txt"]:
    req_path = project_path / req_file
    if req_path.exists():
        requirements.extend(get_requirements_version(req_path))

with open(output, "a") as requirements_version_txt:
    requirements = list(set(req for req in requirements if req))
    for requirement_str in requirements:
        print(requirement_str)
        requirements_version_txt.write(requirement_str + "\n")
