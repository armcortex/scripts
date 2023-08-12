from pathlib import Path
import time

from PIL import Image
import fire


def convert_to_webp(source):
    """Convert image to webp.

    Args:
        source (pathlib.Path): Path to source image

    Returns:
        pathlib.Path: path to new image
    """
    new_file_name = source.stem + ".webp"
    destination = source.parent.parent / new_file_name

    image = Image.open(source)
    image.save(destination, format="webp")
    return destination


def get_file_size(file_path):
    """Calculate file size.

    Args:
        source (pathlib.Path): Path to source image

    Returns:
        file size in MB unit
    """
    return file_path.stat().st_size / 1024


def convert(image_path, source_format='jpg'):
    t0 = time.perf_counter()

    p = Path(image_path)
    if not any(p.glob(f'**/*.{source_format}')):
        print(f'{source_format.upper()} not found')
        return 

    file_cnt = 0
    org_size_total = 0
    convert_size_total = 0
    for path in p.glob(f'**/*.{source_format}'):
        webp_path = convert_to_webp(path)
        org_size = get_file_size(path)
        convert_size = get_file_size(webp_path)
        ratio = org_size / convert_size
        print(f'Path: {path}, Original Size: {org_size:.1f} KB, '
                f'Convert Size: {convert_size:.1f} KB, Ratio: {ratio:.1f}')
        file_cnt += 1
        org_size_total += org_size
        convert_size_total += convert_size

    t1 = time.perf_counter()
    total_ratio = org_size_total / convert_size_total
    print()
    print(f'Execute Time: {t1-t0:.2f} sec, '
            f'Convert total files: {file_cnt}, '
            f'Total Original Size: {org_size_total/1024:.1f} MB, '
            f'Total Convert Size: {convert_size_total/1024:.1f}MB, '
            f'Ratio: {total_ratio:.1f}')


if __name__ == '__main__' :
    # Usage
    # python image2webp.py --help
    # python image2webp.py '../portfolio/content/hobby/superbike/images/small/raw' --source_format='jpeg'
    fire.Fire(convert)
