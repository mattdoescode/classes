# soil moisture levels

# number of nodes

# users add or remove nodes

# pauseable program

# The algorithms I’d like to simulate would be pathfinding (energy saving, shortest path),
# neighborhood management (density of nodes vs memory), auto assigning node role and node
# time syncing (nodes send data at staggering determined times, allowing the router to go sleep).
# I will gladly add or remove any at your discretion.

# Visual of map / with nodes + coordinates
# plot showing current soil moisture levels
# state / attribue of each node with
# Object node

# add and remove nodes

print("\n")
print("Visual Sensor Network - With Interactive Terrain")
print("Matthew Loewen 12/17/2020 \n")

from opensimplex import OpenSimplex
# https://pypi.org/project/opensimplex/
import numpy
import pygame
import time
import math
import csv

#code to run the nodes
import Node

#collection of our nodes
nodes = []

tmp = OpenSimplex(seed=45633)

CONSTmapSize = 1000, 1000
#color array of points
heights = numpy.zeros(CONSTmapSize[0]*CONSTmapSize[1], dtype=(float,3))
#values of said points before color conversion
themap = numpy.zeros((CONSTmapSize[0], CONSTmapSize[1]))

#convert from 1 number range to another
def convert_range(min, max, newMin, newMax, oldValue):
    oldRange = max - min
    newRange = newMax - newMin
    newValue = (((oldValue - min) * newRange) / oldRange) + newMin
    return newValue

#create terrain
print("Generating terrain.")
for x in range(CONSTmapSize[0]):
    for y in range(CONSTmapSize[0]):
        nx = x/CONSTmapSize[0] - 0.5
        ny = y/CONSTmapSize[1] - 0.5

        # zoom in or out
        frequency = 6

        nx = nx * frequency
        ny = ny * frequency

        # add detail "octaves"
        themap[x][y] = convert_range(0, 2, 0, 255, 1 * tmp.noise2d(1 * nx, 1 * ny) +
                                     0.5 * tmp.noise2d(2 * nx, 2 * ny) + 0.25 * tmp.noise2d(6 * nx, 6 * ny) + 1)

        # print(themap[x][y])

print("Terrain Created")

# colors
water = (0, 0, 255)
sand = (210, 180, 140)
lightGrass = (112, 130, 56)
heavyGrass = (11, 102, 35)
rock = (139, 137, 137)
snow = (255, 250, 255)

def changeWaterLevel(changeAmt):

    #WHY THE HECK DO THESE HAVE TO BE GLOBAL VARIABLES?!
    global waterLevel
    waterLevel = waterLevel + changeAmt
    if waterLevel < 0:
        waterLevel = 0
    elif waterLevel > 255:
        waterLevel = 255
    global changedTerrain
    changedTerrain = True
    print("Water Level is now: ", waterLevel)

#what pixel to what color
def computeHeights():
    print("Starting to compute Terrain")
    elem = 0
    for x in range(CONSTmapSize[0]):
        for y in range(CONSTmapSize[0]):
            if themap[x][y] <= waterLevel:
                color = water
            elif themap[x][y] <= 100:
                color = sand
            elif themap[x][y] <= 140:
                color = lightGrass
            elif themap[x][y] <= 200:
                color = heavyGrass
            elif themap[x][y] <= 235:
                color = rock
            else:
                color = snow
            
            heights[elem] = color
            elem = elem + 1
    print("Computed heights")

def screenshot():
    time_taken = time.asctime(time.localtime(time.time()))
    time_taken = time_taken.replace(" ", "_")
    time_taken = time_taken.replace(":", "-")
    save_file = "screenshots/" + time_taken + ".png"
    pygame.image.save(screen, save_file)
    print("screen saved")
    return save_file

def showRaw():
    elem = 0
    for x in range(CONSTmapSize[0]):
        for y in range(CONSTmapSize[0]):    
            screen.set_at((x, y), (heights[elem]))
            elem = elem + 1

def loadImage(name):
    screen.blit(pygame.image.load(name),(0,0))


idCount = 0
def makeNode(name):
    global idCount
    idCount = idCount + 1
    nodes.append(Node.Node(name, pygame.mouse.get_pos(), idCount))

def deleteNode():
    toDelete = len(nodes)
    nodes.pop(toDelete-1)


green = (0,255,0)
red = (255,0,0)
def checkNodes():

    print("checking radio ranges")

    for node in nodes:
        node.isTounching = []
        node.colorChange(red)
    
    counter = 0
    for nodeouter in range(len(nodes[:-1])): 
        counter = counter + 1
        for nodeinner in range((len(nodes) - counter)):
            
            dist = math.sqrt(((nodes[nodeinner + counter].location[0] - nodes[nodeouter].location[0])**2) + ((nodes[nodeinner + counter].location[1] - nodes[nodeouter].location[1])**2))

            #this SHOULD work with different range nodes
            #this is untested and not implemented

            #calculation of touching needs to optimized
            #some storing of dup. connections
            #HAD ERROR? of first node not having any connections
            if(dist <= (nodes[nodeouter].range)):
                nodes[nodeouter].colorChange(green)
                nodes[nodeouter].isTounching.append(nodes[nodeinner+counter])
            if(dist <= (nodes[nodeinner + counter].range)):
                nodes[nodeinner + counter].colorChange(green)
                nodes[nodeinner+counter].isTounching.append(nodes[nodeouter])

# detection does not work 100% of the time....
# but why?
def detectWater():
    for node in nodes:
        if themap[node.location[0]][node.location[1]] >= waterLevel:
            node.dectedColor = (0,255,0)
        else:
            node.dectedColor = (255,0,0)

#OPTIMIZE HOW THIS WORKS
def drawTouching(surface):
    for node in nodes:
        #print("evaluating node: ", node.id)
        if node.role[0] == "R":
            for touched in node.sendTouching():
                #print("touched: ", touched.id)
                if touched.role[0] == "E":
                    node.drawConnection(touched, surface, (255,211,25))
                elif touched.role[0] == "C":
                    node.drawConnection(touched, surface, (21,178,211))
                elif touched.role[0] == "R":
                    node.drawConnection(touched, surface, (192,100,100))



#make a list of neighbor nodes
def callNeighbors():
    for node in nodes:
        #print("computing node", node.id)
        node.collection = []
        node.payload = []
        for inner in nodes:
            if node.id == inner.id:
                continue
            dist = math.sqrt(((node.location[0] - inner.location[0])**2) + ((node.location[1] - inner.location[1])**2))
            #print(dist)
            if dist <= node.range: 
                #print("neighbor added:", inner.id)
                node.collection.append(inner)


# COMMUNICATION 
#Works with 3 pieces of information
    # NODE ID
    # boolean - is water detected
    # message livespan - a message can be tranmitted from a node to a node 5 times

def clearPayload():
    for node in nodes:
        node.payload = []

#how many nodes it can visit
message_strength = 5

# POSSIBLE BUG WHERE SOME messages should be deleted are not 
def report(node):
    
    print("reporting for node:", node.id)

    # End node sending to router
    if node.role[0] == "E":

        clearPayload()

        for connection in node.collection:
            if connection.role[0] == "R":
                print("end node", node.id, "sending to router", connection.id)
                if node.dectedColor == (255,0,0):
                    connection.payload.append([node.id,True,message_strength-1])
                elif node.dectedColor == (0,255,0):
                    connection.payload.append([node.id,False,message_strength-1])
                report(connection)

    # router sending to router
    # router sending to coord    
    if node.role[0] == "R":
        for connection in node.collection:
            if connection.role[0] == "R":
                for message in node.payload:
                    #print("copying from router: ", node.id, "to router:", connection.id)
                    message[2] = message[2] - 1
                    #print(message[2])
                    if message[2] <= 0: 
                        print("dead message")
                    else: 
                        connection.payload.append(message)
                        report(connection)

            elif connection.role[0] == "C":
                data = node.payload[0]
                data[2] = data[2] - 1
                if data[2] >= 0:
                    print("Coord has recieved message", data[0], data[1], data[2])
                    appendToCSV(data)

    ###
        #### THIS IMPLEMENTATION DOES NOT WORK. IGNORE... FOR NOW....
    ###
    # # in case of end node to router
    # if node.role[0] == "E":
    #     for neighbor in node.collection:
    #         if neighbor.role[0] == "R":
    #             print("reporting connection from end note to router")
    #             if node.dectedColor == (255,0,0):
    #                 neighbor.payload.append([node.id,True])
    #             elif node.dectedColor == (0,255,0):
    #                 neighbor.payload.append([node.id,False])
    #         for info in neighbor.payload:
    #             print("printing router info: " )
    #             print(info[0], info[1])

    # #in case of router to router
    # if node.role[0] == "R":
    #     for neighbor in node.collection:
    #         if neighbor.role[0] == "R":
    #             print("reporting connection from router to router")

    #             #we want to share information from router to neighbor
    #             for info in node.payload:
    #                 print("copying over 1 record")
    #                 neighbor.payload.append(info)

    #             #WE ALSO want to share from neighbor to router
    #             for info in neighbor.payload:
    #                 print("copting over 1 record")
    #                 node.payload.append(info)

    # # in case of router to coordinator
    # if node.role[0] == "R":
    #     for neighbor in node.collection: 
    #         if neighbor.role[0] == "C":
    #             print("reporting connection from router to coordinator")
    #             for info in node.payload:
    #                 print("copying record over")
    #                 neighbor.payload.append(info)

    # # if coordinator print out everything
    # if node.role[0] == "C":
    #     for info in node.payload:
    #         print(type(info))
    #         print(info[0], info[1])

def appendToCSV(data):
    with open("readings" + '.csv', 'a', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(data)

#eventually do all of this in PostgresSQL
print("Creating CSV file to store results")
headinfo = ["sensorID","inWater","hops-left"]
with open("readings" + ".csv", 'w', newline='') as csvFile:
    fileWriter = csv.writer(csvFile, delimiter=',', quotechar='|', quoting=csv.QUOTE_MINIMAL)
    fileWriter.writerow(headinfo)

print("Controls are as follow: ")
#add in control instructions

pygame.init()
screen = pygame.display.set_mode([CONSTmapSize[0], CONSTmapSize[1]])
font = pygame.font.SysFont(None, 64)

running = True
paused = False

#does the hight map need to be calculated
changedTerrain = True

#clock for FPS
clock = pygame.time.Clock()

#location of last saved screenshot
newScreenCap = ""
# Starting water level
waterLevel = 230
toggle = True
connections = True

# main program loop
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            quit()
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_p:
                paused = not paused
            if event.key == pygame.K_m:
                changeWaterLevel(-20)
            if event.key == pygame.K_k:
                changeWaterLevel(20)
            if event.key == pygame.K_c:
                makeNode("Coordinator")
            if event.key == pygame.K_r:
                makeNode("Router")
            if event.key == pygame.K_e:
                makeNode("EndNode")
            if event.key == pygame.K_t:
                toggle = not toggle        
            if event.key == pygame.K_u:
                checkNodes()
            if event.key == pygame.K_d:
                nodes = []
            #delete nodes by ID
            if event.key == pygame.K_a:
                deleteNode()
            if event.key == pygame.K_j:
                detectWater()
            if event.key == pygame.K_y:
                connections = not connections
            if event.key == pygame.K_l:
                callNeighbors()
                for node in nodes:
                    if node.role[0] == "E":
                        report(node)

    if(not paused):
        if changedTerrain:
            screenshot()
            computeHeights()
            showRaw()
            newScreenCap = screenshot()
            #loadImage(newScreenCap)
            detectWater()
            changedTerrain = False
        else:
            loadImage(newScreenCap)
            for node in nodes:
                node.show(screen, font, toggle)
        
        if connections:
            drawTouching(screen)
    
        pygame.display.flip()

    clock.tick(30)