from gedcom.element.individual import IndividualElement
from gedcom.parser import Parser


def grab_name(element):
    (first, last) = element.get_name()
    if last == '':
        return first
    else:
        return first + " " + last


children = []
sex = []

gedcom_parser = Parser()
gedcom_parser.parse_file('windsor_dynasty.ged')
root_child_elements = gedcom_parser.get_root_child_elements()

for element in root_child_elements:
    if isinstance(element, IndividualElement):
        name = grab_name(element)
        gender = element.get_gender()
        sex.append(f"sex('{name}', '{gender}').\n")
        if element.is_child():
            for parent in gedcom_parser.get_parents(element, "ALL"):
                name_parent = grab_name(parent)
                children.append(f"child('{name}', '{name_parent}').\n")

with open('data.pl', 'w') as data:
    data.writelines(children)
    data.writelines(sex)