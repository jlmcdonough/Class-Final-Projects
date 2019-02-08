# CMPT 120L 113
# Joseph McDonough  
# 3 Dec 2018
# Version 1
###

##Version 1.0 Commit 3
#Added injured Boolean. Player has a 10% chance to get injured at any given point when moving between locations
#Injured cause probability of survival to go down but by using some medical supplies found around the map, they can
#get their health back up
#Put injured() atop each locale call so before the reach their new destination, the chance to get hurt occurs
#Updated updateGame() to account for the use of meds
##

from random import randint
from Locale import Locale
from Player import Player

header = "\n~~~~~~~~~~~~\n"
title = header + " LAST STAND" + header
ownership = "\nCopyright (c) 2018 Joseph McDonough, Joseph.McDonough1@marist.edu"
global moveLimit
moveLimit=randint(17,20)
itemFound = "ITEM FOUND: "
mapFound = False
keyFound = False
vitaminsUsed = False
useableItems = []   #Need this because even when an item has 0 uses, I want it in the inventory, but can't let it be used
injured = False
player = Player(" "," ")


#locales
home = Locale("apartment", ("\nYou arrive back at home and now have more resources. You are still limited and decide "
                                "to go back and search in the morning.  You feel good and have confidence that you'll be able to "
                               "outlast the quarantine and make it home.  You are still patiently waiting to hopefully stumble upon  "
                               "your neighbor's key..."),1,3)

street = Locale("street",("\nYou don't really know where to go and so explore the streets.  You discover a dead body "
                                "that seems to have been there for a few days.  You notice something shiny sticking out of the breast "
                                "pocket.  You take it out and notice it is a key.   There are a million places where this can go but you take it "
                                "regardless..."), 5,10)
street.addItem("Unknown key",0)

subway = Locale("subway station",("\nYou return to the subway station. This is the place where you woke up "
                        "that first night. It appears as if the tracks haven't been used in days and its probably going "
                        "to stay that way. You look around and do not find anything of much use..."), -5,-2)
              
supermarket = Locale("supermarket",("\nYou spot this massive store in the distance with all of the lights out.  "
                            "You venture inside and notice that this was the local supermarket.  You rummage through the "
                            "store gathering all the food you can find, your bag gets full and you head back out..."), 3,7)
supermarket.addItem("2 tins of spam and bottled water", 0)

generalStore = Locale("general store",("\nAnother store has its lights on in the distance and you go to investigate. "
                            "Luckily for you, this store seems like it used to sell everything. The glass on the door is "
                            "long gone and you walk in and start scavenging. You notice seemingly new footprints in the "
                            "snow but pay no mind to it. In the store is basic supplies and medicine that you should take "
                            "back to your house..."), 5,10)
generalStore.addItem("Antibiotics and a medkit", 2)

clothingStore = Locale("clothing store", ("\nYou head out and find a clothing store and they have a lot of clothes, "
                                "but nothing you need. You decide to take what you can and see if you can fashion your "
                                "own clothes back home.  As you make your way out, a gang appears a few houses down, "
                                "they spot you and they start to ambush you. You should try to run home..."), 1,5)
clothingStore.addItem("Two oversized t-shirts", 0)

hospital = Locale("hospital",("\nYou stumble upon the abandoned hospital.  This place was overrun by the infected. "
                        "You cautiously walk around. The first floor is vacant and there is nothing of use.  You hear "
                        "noises above you.  It is not worth the risk considering you aren't too desparate yet and there "
                        "probably is nothing anyways.  You leave this dangerous place behind..."), -5,-2)

armory = Locale("armory", ("\nAfter strolling about, looking for stuff, you spot a little store that you've never "
                        "seen.  The glass doors are shattered and so you walk inside.  You see the sign for London "
                        "Armoury Company and notice the empty gun racks on the walls.  After a little bit of exploring, "
                        "you don't find any big weapons but you do find a sidearm in one of the drawers... "), 7,10)
armory.addItem("Pistol with 5 bullets in the magizine",0)

wembley = Locale("wembley", ("\nYou are walking and you notice the arch is right in front of you. You reach Wembley "
                        "Stadium, the center of English football.  You remember coming to the last year's FA Cup "
                        "Finals and Tottenham finally lifting a trophy.  These memories are bittersweet because life has "
                        "not been the same. As you start to regret coming here, you notice a large piece of paper on the "
                        "floor.  You pick it up and notice it is a map of the city.  Now you feel like you have benefitted "
                        "from this trip and leave happy..."), 7,10)
wembley.addItem("Map",0)

warehouse = Locale("warehouse", ("\nThis building is definitely going to be useless.  You walk inside of "
                            "this massive building that looks like it caught on fire.  Inside are many cardboard boxes, "
                            "charred and consumed.  After further investigation, you make out the Amazon logo on one of "
                            "the boxes.  This must have been their warehouse. You walk around for a little longer and "
                            "cannot seem to find anything of use to you in your current state.  Back out you go..."), -5,-2)

lockedRoom = Locale("locked room", ("\nYou have FINALLY found the key to open your neighbor's apartment.  Hopefully that body wasn't his... "
                      "Regardless, you enter the apartment and scavenge for whatever you can find.  Everything is empty or "
                      "rotten except for some vitamins in one of the cupboards.  You take those back with you to your place...\n"
                      "ITEM FOUND: VITAMINS \nITEM ACQUIRED!"), 0,0)
localeList = [home, street, subway, supermarket, generalStore, clothingStore, hospital, armory, wembley, warehouse]

def getInjured():    #function to determine if the user fell when moving between locations
    chanceOfInjury = int(randint(1,40))   #there are 4 instances in which the user can get hurt, wanted 4 different parts
    if (chanceOfInjury == 1 and not player.injured):     #dont want to let the player stack up injuries
        player.injured = True
        print("\nYou fell on some black ice and slice your left arm upon impact.  It's not too bad but you need to find some medical supplies...")
        print(probOfSurv(int(randint(-5,-2))))
    elif (chanceOfInjury == 11 and not player.injured):   #Did not want 1,2,3,4 to be the chances because why not,                             
        player.injured = True                                             #so each number ending in 1 represents a different body part
        print("\nDown you go on some ice you failed to spot.  You cut your right arm as you land and need some medical supplies to patch it up...")
        print(probOfSurv(int(randint(-5,-2))))
    elif (chanceOfInjury == 21 and not player.injured):
        player.injured = True
        print("\nYou tripped on some trash and a rusty screw punctured your left leg. Hopefully it is not infected or maybe some antibiotics would help...")
        print(probOfSurv(int(randint(-5,-2))))
    elif (chanceOfInjury == 31 and not player.injured):
        player.injured = True
        print("\nYou walked too close to the building on your right and a piece of stray glass sliced your right leg.  You should be fine but a bandage would be nice...")
        print(probOfSurv(int(randint(-5,-2))))
        
def printInventory():
    print("You currently have: ")
    for x in player.inventory:
        if (x == "Antibiotics and a medkit"):  #general store is the only place that gives an item with limited uses     
            print("\n\t"+u"\u00BB", x, ".  Uses remaining: " + str(generalStore.uses))
        elif (x == "Vitamins" and not vitaminsUsed):
            print("\n\t"+u"\u00BB", x, ".  Uses remaining: " + str(1))
        elif (x == "Vitamins" and vitaminsUsed):
            print("\n\t"+u"\u00BB", x, ".  Uses remaining: " + str(0))
        else:
            print("\n\t"+u"\u00BB", x)

def hasInList(listName, elem):
    for x in listName:
        if (x==elem):
            return True
    return False

def take(locale):    
    print(itemFound + str(locale.item))    #prints the item found message regardless of if an item is present or not
    if(locale.item!=None):                 #as long as there is an item at that location, it will enter the while loop asking the user if they want to pick up the available items
        tempBoolean = True
    else:
        print("There are no items to be picked up here.")    #if no items are to be picked up, user is notified
        tempBoolean = False
    while tempBoolean:
        takingIt = input("Would you like to take the item found? (Y/N) ")     #prompts user to pick up or leave item
        if(takingIt.lower().strip()=="y"):
            player.inventory.append(locale.item)          #takes the item and puts it into the user inventory
            if(locale.item=="Map"):                       # if the map is what is found, and then accepted, the user now has access to the map command
                global mapFound
                mapFound = True
            if(locale.name==generalStore.name):
                useableItems.append(locale.item)
            if(locale.name==street.name):
                useableItems.append(locale.item)
                global keyFound
                keyFound = True
            locale.item=None          #clears the location of the items --> locale dicitonary item now holds none
            tempBoolean = False      #exits loop
            print("ITEM ACQUIRED!")   #lets user know they successfully pick up a new item
        elif(takingIt.lower().strip()=="n"):
            break                    #if they don't want the item, nothing happens
        else:
            print('You are not entering a valid command. Please type "Y" or "N".')
            
def goHome():
    getInjured()
    player.locationDescription = home.description
    player.locationName = home.name
    print(player.locationDescription)
    take(home)
    if(not home.hasBeen):
          print(probOfSurv(home.chance))
          home.hasBeen = True
    player.movesMade +=1
    
def goStreet():
    getInjured()
    player.locationDescription = street.description
    player.locationName = street.name
    print(player.locationDescription)
    take(street)
    if(not street.hasBeen):
          print(probOfSurv(street.chance))
          street.hasBeen = True
    player.movesMade +=1
    
def goSubway():
    getInjured()
    player.locationDescription = subway.description
    player.locationName = subway.name
    print(player.locationDescription)
    take(subway)
    if(not subway.hasBeen):
          print(probOfSurv(subway.chance))
          subway.hasBeen = True
    player.movesMade +=1
    
def goSupermarket():
    getInjured()
    player.locationDescription = supermarket.description
    player.locationName = supermarket.name
    print(player.locationDescription)
    take(supermarket)
    if(not supermarket.hasBeen):
          print(probOfSurv(supermarket.chance))
          supermarket.hasBeen = True
    player.movesMade +=1
    
def goGeneralStore():
    getInjured()
    player.locationDescription = generalStore.description
    player.locationName = generalStore.name
    print(player.locationDescription)
    take(generalStore)
    if(not home.hasBeen):
          print(probOfSurv(generalStore.chance))
          generalStore.hasBeen = True
    player.movesMade +=1
    
def goClothingStore():
    getInjured()
    player.locationDescription = clothingStore.description
    player.locationName = clothingStore.name
    print(player.locationDescription)
    take(clothingStore)
    if(not clothingStore.hasBeen):
          print(probOfSurv(clothingStore.chance))
          clothingStore.hasBeen = True
    player.movesMade +=1
    
def goHospital():
    getInjured()
    player.locationDescription = hospital.description
    player.locationName = hospital.name
    print(player.locationDescription)
    take(hospital)
    if(not hospital.hasBeen):
          print(probOfSurv(hospital.chance))
          hospital.hasBeen = True
    player.movesMade +=1
    
def goArmory():
    getInjured()
    player.locationDescription = armory.description
    player.locationName = armory.name
    print(player.locationDescription)
    take(armory)
    if(not armory.hasBeen):
          print(probOfSurv(armory.chance))
          armory.hasBeen = True
    player.movesMade +=1

def goWembley():
    getInjured()
    player.locationDescription = wembley.description
    player.locationName = wembley.name
    print(player.locationDescription)
    take(wembley)
    if(not wembley.hasBeen):
          print(probOfSurv(wembley.chance))
          wembley.hasBeen = True
    player.movesMade +=1

def goWarehouse():
    getInjured()
    player.locationDescription = warehouse.description
    player.locationName = warehouse.name
    print(player.locationDescription)
    take(warehouse)
    if(not warehouse.hasBeen):
          print(probOfSurv(warehouse.chance))
          warehouse.hasBeen = True
    player.movesMade +=1

def goLockedRoom():   #Can't fall on ice when moving between rooms in a building
    player.locationDescription = lockedRoom.description
    player.locationName = lockedRoom.description
    print(player.locationDescription)
    if(not lockedRoom.hasBeen):
        lockedRoom.hasBeen = True
        lockedRoom.updateDescription("You have already looted this room. Time to move on...")
        home.updateDescription("\nYou arrive back at home and now have more resources. You are still limited and decide "
                            "to go back and search in the morning.  You feel good and have confidence that you'll be able to "
                           "outlast the quarantine and make it home.  It also feels good knowing you finally got into that apartment..." )

def updateGame(userInput):      
    global vitaminsUsed
    direction = userInput
    cantGo = ("\n You head " + direction + " and notice the quarantine zone border.  You cannot continue in that direction.")
    if (userInput == "use key" and player.locationName == home.name and keyFound==True and not lockedRoom.hasBeen):
        goLockedRoom()
        player.inventory.append("Vitamins")
        useableItems.append("Vitamins")
        goHome()
    elif (userInput == "use key" and player.locationName == home.name and keyFound==True and lockedRoom.hasBeen):
        print("You have already opened the room and collected everything inside, time to move on.")
    elif (userInput == "use key" and player.locationName != home.name and keyFound == True):
        print("You look around and see nowhere for the key to be used...")
    elif (userInput == "use key" and player.locationName == home.name and keyFound == False):
        print("You still do not have the sufficent key to open the door...")
    elif (userInput == "use key" and player.locationName != home.name and keyFound == False):
        print("What key?")
    elif (userInput == "use vitamins" and hasInList(useableItems,"Vitamins")):
        print("Vitamins successfully used")
        print(probOfSurv(int(randint(5,10))))
        vitaminsUsed = True
        useableItems.remove("Vitamins")
    elif (userInput == "use vitamins" and not hasInList(useableItems, "Vitamins")):
        print("You do not have any more vitamins to use. Keep looking...")
    elif (userInput == "use meds" and player.injured and hasInList(useableItems, "Antibiotics and a medkit")):
        print("You have successfully healed your wound...")
        print(probOfSurv(int(randint(5,8))))
        player.injured = False
        if (generalStore.uses>1):
            generalStore.uses -=1   #subtracts the amount of uses left on the meds
        elif (generalStore.uses ==1):
            generalStore.uses -=1
            useableItems.remove("Antibiotics and a medkit")  #There are now 0 uses left, so now the user cannot use them
    elif (userInput == "use meds" and not player.injured and hasInList(useableItems, "Antibiotics and a medkit")):
        print("Luckily for you, there are no injuries and the medical supplies won't be of any use to you right now...")
    elif (userInput == "use meds" and  player.injured and not hasInList(useableItems, "Antibiotics and a medkit")):
        print("You do not have any medical supplies to help you with this injury.  Keep looking before it gets worse...")
    elif (userInput == "use meds" and not player.injured and not hasInList(useableItems, "Antibiotics and a medkit")):
        print("What medical supplies? What wounds?")
             
    elif(direction=="north"):    #Can't go from wembley, clothing, armory, warehouse
        if(player.locationName==home.name):
            goSubway()
        elif(player.locationName==street.name):
            goClothingStore()
        elif(player.locationName==supermarket.name):
            goHome()
        elif(player.locationName==generalStore.name):
            goArmory()
        elif(player.locationName==hospital.name):
            goGeneralStore()
        elif(player.locationName==subway.name):
             goWembley()
        else:
            print(cantGo)
    elif(direction=="south"):     #Can't go from streets, supermarket, hospital, warehouse
        if(player.locationName==home.name):
            goSupermarket()
        elif(player.locationName==subway.name):
            goHome()
        elif(player.locationName==generalStore.name):
            goHospital()
        elif(player.locationName==clothingStore.name):
            goStreet()
        elif(player.locationName==armory.name):
            goGeneralStore()
        elif(player.locationName==wembley.name):
             goSubway()
        else:
            print(cantGo)
    elif(direction=="east"):       #Can't go from warehouse, general, hospital, wembley
        if(player.locationName==home.name):
            goGeneralStore()
        elif(player.locationName==street.name):
            goSupermarket()
        elif(player.locationName==subway.name):
            goArmory()
        elif(player.locationName==supermarket.name):
            goHospital()
        elif(player.locationName==clothingStore.name):
            goHome()
        elif(player.locationName==armory.name):
            goWarehouse()
        else:
            print(cantGo)
    elif(direction=="west"):      #Can't go from wembley, subway, clothing, streets
        if(player.locationName==home.name):
            goClothingStore()
        elif(player.locationName==supermarket.name):
            goStreet()
        elif(player.locationName==generalStore.name):
            goHome()
        elif(player.locationName==hospital.name):
            goSupermarket()
        elif(player.locationName==armory.name):
            goSubway()
        elif(player.locationName==warehouse.name):
            goArmory()
        else:
            print(cantGo)
    else:
        print('You are not entering a valid input. Try again or type "help". ')     #anything entered that is not in the directionHeading array will not be reconginzed and user has to input a new request
    pressEnter()
           
def introCharChoice():      #gets player name and gender, player chooses character type, intro is displayed
    print(title)            #prints game title
    name = input("Welcome player, insert your name: ")                                      #gets name
    gender = input("Thanks " + name + ".  Now select your gender: M/F ")                #gets gender
    setDefault(name, gender)
    print("Now pick your character type:\n")
    options()  #shows all the possible characters with the strength and weaknesses
    player.welcome()  #Greets player before game starts
    print("You were born in Napa Valley, California and graduated from Lowell High School,"      # show game introduction part 1
          " one of the best school in the bay area.  You graduated top 10 in your class"
          " and have had a passion for " +player.passion+
          " ever since you were a little kid.  Unfortunately for you, your"
          " parents owned a lot of land and wanted you to take over the family run"
          " vineyard.  This lifestyle was not for you.  Upon graduating you"
          " wanted to attend "+player.college+ ", one of the best in your field,"
          " but your parents were against it.  They said as long as you lived here, you"
          " would obey them and they would not fund you.  After much consideration,"
          " you decided that you will pursue your own path.  You did not have enough"
          " money to attend the school of your dreams, so you decided to try something"
          " new and go to London, England as you always desired to go there.")
    pressEnter()                                                                                  # prompt the user
    print("\nYou have been in London for 3 years, working " + player.tempJob +                      # character introduction part 2
           " in order to save money and hopefully eventually get a degree. "
           " You were getting close to getting enough money to start school when it happened."
           " All of a sudden, an epidemic has hit the city.  Slowly everyone around you is"
           " getting sick and you need to leave but all flights are grounded and the city"
           " is quarantined until further notice.  Now you need to find a way to survive the"
           " frigid winter all alone...\n" + "You awake to find yourself in complete darkness at a subway station. "
           "You must've spent the night there, but you don't know how you ended up here.  You exit and the sky is clouded and snow is "
           "starting to fall. The power keeps flickering and you don't know where to begin, but you do remember where a lot of the shops are.\n"
           "\nYour starting survival probability is " + str(player.score) + "%.")

def setDefault(name, gender):
    player.name = name
    player.gender = gender
    player.score = int(randint(5,25))
    player.locationName = subway.name   #starting location is subway so assigning that here
    player.locationDescription = subway.description
    player.movesMade = 0
    global mapFound, keyFound, vitaminsUsed, useableItems
    mapFound = False
    keyFound = False
    vitaminsUsed = False
    player.injured = False
    useableItems = []
    for x in localeList:
        x.hasBeen = False
    street.addItem("Unknown key",0)
    supermarket.addItem("2 tins of spam and bottled water", 0)
    generalStore.addItem("Antibiotics and a medkit", 2)
    clothingStore.addItem("Two oversized t-shirts", 0)
    armory.addItem("Pistol with 5 bullets in the magizine",0)
    wembley.addItem("Map",0)

def takeInput(): #takes input and returns normalized input 
    userInput = input('Would you like to go "north", "south", "east", or "west". Or type "help", "map", "inventory", '
                                 ' "use" followed by the item (see help), or "quit": ')
    normInput = userInput.strip().lower()
    return normInput

def helpMenu():
    print("\n Choose the direction you would like to head:"
          "\n\t"+u"\u2023"+"North makes your character head north. \n\t"+u"\u2023"+"South makes your character go south."
          "\n\t"+u"\u2023"+"East makes your character go east. \n\t"+u"\u2023"+"West makes your character go west."
          "\n\t"+u"\u2023"+"Map shows the map of the world (Only if map is found).\n\t"+u"\u2023"+"Inventory shows "
          "what is currently in the users inventory" "\n\t"+u"\u2023"+'Use followed by "key", "vitamins" or "meds" will use said item.'
          "\n\t"+u"\u2023"+"Quit exits the game.")

def renderGame():
    print("\nMOVES MADE: " + str(player.movesMade))
    print("LOCATION: " + player.locationName.upper() + ". SURVIVAL PROBABILITY: " + str(player.score) + "%.") 

def options():     #prints the description for each of the available characters
    Player.display("")
    choice = input("\nEnter the number for the character you wish to play as: ")   #Has player pick character
    if(choice=="1"):
        player.assignRole(1)
    elif(choice=="2"):
        player.assignRole(2)
    elif(choice=="3"):
        player.assignRole(3)
    elif(choice=="4"):
        player.assignRole(4)
    else:
        print("Please enter a number that is listed above")
        options() 

def pressEnter():   #function for prompting player to continue
    input("\n<Press Enter to continue>")

def probOfSurv(chance):   #function for printing probability of surviving
    oldSurv = player.score
    player.score +=chance
    if oldSurv>player.score:
        incOrDec = "decreased"
    else:
        incOrDec = "increased"
    survMsg = ("\nYour probability of survival " + incOrDec + " to " + str(player.score)+ "%.")
    return survMsg

def map():
    print('''
                         Wembley
                            |
                            |
                          Subway -------- Armory ---- Warehouse
                            |                | 
                            |                | 
            Clothing ----- Home --------  General
               |             |                | 
               |             |                | 
            Streets --- Supermarket ---- Hospital    
          ''')

def gameLoop():   #game loop to take input and update game
    global userInput
    while player.movesMade<moveLimit and player.score<=55:
        renderGame()
        userInput=takeInput()
        if (userInput=="quit"):     #exits game
            break
        elif(userInput=="map"):
            if(mapFound):
                map()
            else:
                print("Map is not yet found. Try this again once you find it.")
        elif (userInput=="help"):
            helpMenu()
        elif (userInput=="inventory"):
            printInventory()
        else:
            updateGame(userInput)

def ending():
    if (player.score>55):
        print("Congratulations! You have gathered enough materials and it looks like you should be able to survive long enough to leave.")
    else:
        print("\nYour time has expired.  It seems as if you are stuck here forever.  Better luck next time!")
    print(ownership)     # show credits

def playAgain():
    global player
    again = input('\n Would you like to play again. Enter "Y" or "N": ')    
    if (again.strip().lower() == "y"):
        player.movesMade = 0
        player.inventory = []
        player.score = 0
        main()
    elif (again.strip().lower() == "n"):
        pass
    else:
        print('You are not entering a valid input. Please try again and enter only "Y" or "N".')
        playAgain()
        
def main():  #main function to run game
    introCharChoice()
    gameLoop()
    ending()
    playAgain()

# runs the game
main()
