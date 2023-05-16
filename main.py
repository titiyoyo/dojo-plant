from PIL import Image
print('Hello world !')

im = Image.open('./images/test.png')

# im.show()

from os import walk

tree_file_names = []
for (dirpath, dirnames, filenames) in walk('data'):
    tree_file_names.extend(filenames)
    break

plants = [f'{item[33:-4]}' for item in tree_file_names]
print(plants)

