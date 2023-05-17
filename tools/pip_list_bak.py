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

import pkg_resources
from pathlib import Path

installed_packages: pkg_resources.WorkingSet = pkg_resources.working_set
project_path = Path(__file__).parent.parent
requirements_txt_path = project_path / "requirements.txt"

requirements = []
with open(requirements_txt_path) as requirements_txt:
    for requirement in pkg_resources.parse_requirements(requirements_txt):
        requirement: pkg_resources.Requirement
        requirements.append(requirement.project_name)
        # str(requirement)

res = [""] * len(requirements)

for package in installed_packages:
    package: pkg_resources.DistInfoDistribution
    if package.project_name in requirements:
        i = requirements.index(package.project_name)
        # res.append(f"{package.project_name}=={package.version}")
        res[i] = f"{package.project_name}=={package.version}"
pprint(res)

with open(project_path / "requirements_mac.txt","w") as requirements_mac_txt:
    for requirement in res:
        requirements_mac_txt.write(requirement + "\n")
