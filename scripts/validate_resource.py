import sys
import json
import argparse
from frictionless import Package
from frictionless import validate_resource

parser = argparse.ArgumentParser()
parser.add_argument('--datapackage',
                    default='datapackage.json',
                    help='path to datapackage descriptor file (default: datapackage.json)')
parser.add_argument('resource_name', 
                    help='name of resource that should be validated')
args = parser.parse_args()

def validate(datapackage, resource_name):
  package = Package(datapackage)
  resource = package.get_resource(resource_name)
  report = validate_resource(resource)
  json.dump(report, sys.stdout, indent=2)
  
if __name__ == '__main__':
    validate(args.datapackage, args.resource_name)