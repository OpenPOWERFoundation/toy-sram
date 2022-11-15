#!/usr/bin/python

from optparse import OptionParser
import gdspy


usage = '%prog [options] inFile'
parser = OptionParser(usage=usage)
(options, args) = parser.parse_args()

if len(args) != 1:
   parser.error('Input .gds required.')

inFile = args[0]



gdsii = gdspy.GdsLibrary()
gdsii.read_gds(inFile)

# list of unreferenced cells
c = gdsii.top_level()
print(c)

LayerNames = {
   '64:5'  : 'nwell, label',
   '64:59' : 'pwell, label',
   '67:5'  : 'li1, label',
   '68:5'  : 'met1, label',
   '83:44' : 'text, label'
}

class Polygon:
   def __init__(self, polygon, layer, datatype, properties=None):
      self.polygon = polygon
      self.layer = layer
      self.datatype =  datatype
      self.properties = properties

class PolygonSets:
   def __init__(self, properties):
      self.polygons = []
      self.properties = properties

maxLayers = 300
maxTypes = 300

numLabels = 0
numPolygons = 0
numPolygonSets = 0

# layer/type
labels = []
for i in range(maxLayers):
   labels.append([])
   for j in range(maxTypes):
      labels[i].append([])

polygons = []
for i in range(maxLayers):
   polygons.append([])
   for j in range(maxTypes):
      polygons[i].append([])

for i in range(len(c)):

   b = c[i].get_bounding_box()
   print(f'Cell {i} {b}')

   p = c[i].get_dependencies()
   print(f'Dependencies ({len(p)})')
   for pp in p:
      print(p)

   p = c[i].get_paths()
   print(f'Paths ({len(p)})')
   for pp in p:
      print(pp)

   p = c[i].get_labels()
   #print(f'Labels ({len(p)})')
   for pp in p:
      labels[pp.layer][pp.texttype].append(pp)
      numLabels += 1

   #p = c[i].get_datatypes()
   #print(f'Data Types ({len(p)})')
   #for pp in p:
   #   print(pp)

   # print(f'Text Types')
   # bug in source
   #  texttypes.update(reference.ref_cell.get_textypes())
   #   for l in c[i].get_texttypes():
   #     print(l)

   #p = c[i].get_layers()
   #print(f'Layers ({len(p)})')
   #p = c[i].get_polygons()
   #print(f'Polygons ({len(p)})')

   # keep these as polygonsets? pp.properties belongs to the set only
   p = c[i].get_polygonsets()
   print(f'Polygon Sets ({len(p)})')
   for pp in p:
      for i in range(len(pp.polygons)):
         numPolygons += 1
         polygons[pp.layers[i]][pp.datatypes[i]].append(
            Polygon(pp.polygons[i], pp.layers[i], pp.datatypes[i])
         )
      numPolygonSets += 1


print(f'     Labels: {numLabels}')
print(f'   Polygons: {numPolygons}')
print(f'PolygonSets: {numPolygonSets}')

for i in range(maxLayers):
   for j in range(maxTypes):
      if (len(labels[i][j]) > 0):
         name = LayerNames[f'{i}:{j}']
         print(f'{i:3d}:{j:3d} {name}')
         for k in range(len(labels[i][j])):
            label = labels[i][j][k]
            print(f'  {label.text} {label.position}')
