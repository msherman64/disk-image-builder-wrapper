import os
import subprocess

import yaml


def _build_image_command(extra_env_vars,elements, dib_release, dib_arch):
    element_str = " ".join(elements)
    output_file = f"/opt/image_output/{dib_release}-{dib_arch}"


    process_env = os.environ.copy()
    process_env.update(extra_env_vars)

    apt_cache_dir = process_env.get("APT_CACHE")
    process_env["ARCH"]=dib_arch
    process_env["DIB_RELEASE"]=dib_release
    process_env["DIB_DEBOOTSTRAP_EXTRA_ARGS"]=f"--cache-dir {apt_cache_dir}"

    command = [
        "disk-image-create",
        "-a", dib_arch,
        "-t","raw",
        "--no-tmpfs",
        "-o", output_file,
        element_str
    ]

    result = subprocess.run(command, check=True, env=process_env)
    return result


config = None
with open("config.yml") as f:
    config = yaml.safe_load(f)


base_elements = config.get("base_elements",[])
os_envs = os.environ
base_envs = config.get("base_env_vars",[])

for distro in config.get("distros",[]):
    extra_elements = distro.get("extra_elements",[])
    element_list = base_elements + extra_elements
    for release in distro.get("dib_release"):
        for arch in distro.get("dib_arch"):
            try:
                _build_image_command(base_envs, element_list, release, arch)
            except subprocess.CalledProcessError as ex:
                print(ex)
                continue
            except TypeError as ex:
                print(f"check syntax of config file!", ex)
                continue


