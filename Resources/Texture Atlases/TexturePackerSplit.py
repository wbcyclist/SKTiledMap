#!python
import os
import sys
from xml.etree import ElementTree

from PIL import Image


def endwith(s, *endstring):
    array = map(s.endswith, endstring)
    if True in array:
        return True
    else:
        return False


# Get the all files & directories in the specified directory (path).
def get_recursive_file_list(path):
    current_files = os.listdir(path)
    all_files = []
    for file_name in current_files:
        full_file_name = os.path.join(path, file_name)
        if endwith(full_file_name, '.plist'):
            full_file_name = full_file_name.replace('.plist', '')
            all_files.append(full_file_name)

        if os.path.isdir(full_file_name):
            next_level_files = get_recursive_file_list(full_file_name)
            all_files.extend(next_level_files)
    return all_files


def tree_to_dict(tree):
    d = {}
    for index, item in enumerate(tree):
        if item.tag == 'key':
            if tree[index + 1].tag == 'string':
                d[item.text] = tree[index + 1].text
            elif tree[index + 1].tag == 'true':
                d[item.text] = True
            elif tree[index + 1].tag == 'false':
                d[item.text] = False
            elif tree[index + 1].tag == 'dict':
                d[item.text] = tree_to_dict(tree[index + 1])
    return d


def gen_png_from_plist(plist_filename, png_filename):
    file_path = plist_filename.replace('.plist', '')
    big_image = Image.open(png_filename)
    root = ElementTree.fromstring(open(plist_filename, 'r').read())
    plist_dict = tree_to_dict(root[0])
    to_list = lambda y: y.replace('{', '').replace('}', '').split(',')
    for k, v in plist_dict['frames'].items():
        rectlist = to_list(v['frame'])
        width = int(rectlist[3] if v['rotated'] else rectlist[2])
        height = int(rectlist[2] if v['rotated'] else rectlist[3])
        box = (
            int(rectlist[0]),
            int(rectlist[1]),
            int(rectlist[0]) + width,
            int(rectlist[1]) + height,
        )
        sizelist = [int(x) for x in to_list(v['sourceSize'])]
        rect_on_big = big_image.crop(box)

        if v['rotated']:
            rect_on_big = rect_on_big.rotate(90)

        result_image = Image.new('RGBA', sizelist, (0, 0, 0, 0))
        if v['rotated']:
            result_box = (
                (sizelist[0] - height) / 2,
                (sizelist[1] - width) / 2,
                (sizelist[0] + height) / 2,
                (sizelist[1] + width) / 2
            )
        else:
            result_box = (
                (sizelist[0] - width) / 2,
                (sizelist[1] - height) / 2,
                (sizelist[0] + width) / 2,
                (sizelist[1] + height) / 2
            )
        result_image.paste(rect_on_big, result_box, mask=0)

        outfile = (file_path + '/' + k).replace('gift_', '')
        (n_filepath, n_filename) = os.path.split(outfile)
        if not os.path.exists(n_filepath):
            os.makedirs(n_filepath)
        #outfile = outfile + '.png'
        print outfile, "generated"
        result_image.save(outfile)


if __name__ == '__main__':
    for filename in sys.argv:
        file_plist = filename + '.plist'
        file_img = filename + '.png'
        if os.path.exists(file_plist) and os.path.exists(file_img):
            gen_png_from_plist(file_plist, file_img)
        else:
            print "make sure you have boith plist and png files in the same directory"