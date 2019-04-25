/**
 * Joseph McDonough and Patrick McNamara
 * CMPT 220L-200
 * 4 April 2019
 * HallwaySim v4.0
 */
package hallSim;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.*;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class HallwaySimulator {
	public static String currentPosition;  //holds the current location
	public static boolean gameOn;          //control for the game loop. true until user enters "quit"
	public static boolean canGo;           //control for update message. won't print if the user cannot walk in desired direction
	public static int monster;             //variable for the random number to determine monster event
	public static int score;               //variable for the users score
	public static Room [] location = new Room [8];  //list containing all the room objects
	public static String currentDescription;  //holds the description of the current location
	public static ArrayList<String> inventory = new ArrayList<String>(); //holds player inventory
	public static boolean mapFound;       //updates to true once player finds the map
	public static int roomId;             //variable that holds the index of each room
	public static boolean inShop;         //control for the magic shop
	public static int goldAmount;          //amount of gold user has
	public static ArrayList<MagicShopItems> magicItems = new ArrayList<MagicShopItems>();  //magic shop's inventory
	public static int pageCount; 			//variable that holds the page count 
	public static ArrayList<Integer> highScoreList = new ArrayList<Integer>(10);  //keeps track of high scores to be put into file
	public static void main(String[] args) {
	guiFrame myFrame = new guiFrame();
	myFrame.setVisible(true);
		Stack<String> locationStack = new Stack<String>();
		Queue<String> locationQueue = new LinkedList<String>();
		Random rand = new Random();
		String direction = "";
		gameOn = true;
		mapFound = false;
		score = 0;
		System.out.println("HALLWAY SIMULATOR");  //title

		location [0] = new Room(0, "LABORATORY", "Welcome to the Laboratory!");
		location [1] = new Room(1, "CLASSROOM", "Welcome to the Classroom!");
		location[1].addItem("WATCH");
		location [2] = new Room(2, "GYM", "Welcome to the Gym!");
		location [3] = new Room(3, "MAGIC SHOP", "Welcome to the Magic Shop!");
		location [4] = new Room(4, "NURSE", "Welcome to the Nurse's Office!");
		location[4].addItem("BINOCULARS");
		location [5] = new Room(5, "OFFICE", "Welcome to the Main Office!");
		location[5].addItem("COMPASS");
		location [6] = new Room(6, "CAFE", "Welcome to the Cafeteria!");
		location [7] = new Room(7, "AUDITORIUM", "Welcome to the Auditorium!");
		location[7].addItem("MAP");
		
		currentPosition = location[0].getName();
		
		File fileShop = new File("magicList");
		Scanner magicScanner;
		try {
			magicScanner = new Scanner(fileShop);
		for(int i = 0; i<=666; i++)
		{
			int itemCost = rand.nextInt(20)+1;
			String itemName = magicScanner.nextLine();
			MagicShopItems temp = new MagicShopItems(itemName, itemCost);
			magicItems.add(temp);
		} 
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		pageCount = (int) Math.ceil((float)magicItems.size()/10);  //takes the size of the list and divides it by ten, then rounds up. That's the page number
		
		Collections.sort(magicItems, new Comparator<MagicShopItems>() 
		{
		    public int compare(MagicShopItems m1, MagicShopItems m2)
		    {
		        return m1.getName().compareTo(m2.getName());
		    }
		});
		
	/*	File fileScores = new File("highScores");
		Scanner scoreScanner;
		try {
			scoreScanner = new Scanner(fileScores);
		for(int i = 0; i<=10; i++)
		{
			int highScore = scoreScanner.nextInt();
			highScoreList.add(highScore);
		} 
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} */
		
		System.out.println("STARTING LOCATION: LABORATORY" + "\t STARTING SCORE: 0" + "\t YOUR GOLD: " + goldAmount);  //Starting message
		while (gameOn) {  //game loop
			Scanner in = new Scanner(System.in);
			monster = rand.nextInt(5);  //generators a number for monster event
			System.out.print("\nEnter a command or 'h' for help: ");
			direction = in.nextLine();
			if (direction.equals("skip") || direction.equals("dance")) //if users wants to skip or dance, a special question line and message is used
			{  
				System.out.print("Chose a direction to go: "); //since user is skipping, they now choose a direction
				String dir2 = in.nextLine();   
				getInput(currentPosition, dir2, locationQueue,locationStack);
				if(canGo)
				{
					System.out.println("You " + direction + " into the " + currentPosition);
					System.out.println(currentDescription);
					Room thisRoom = location[roomId];
					goldAmount+= thisRoom.getGold();
					take(thisRoom);
					thisRoom.nowBeen();
					locationStack = locationTrail(thisRoom.getName(), locationStack);
					locationQueue = locationTrail(thisRoom.getName(), locationQueue);
					System.out.println("LOCATION: " + currentPosition  + "\t SCORE: " + score + "\t YOUR GOLD: " + goldAmount);  //updates user with current location and score info
				}
			} else 
				{
				getInput(currentPosition, direction, locationQueue,locationStack);  //user doesn't want to skip or dance, assumes they walk or enter a different command
				if(canGo)
					{
					System.out.println("You walk to the " + currentPosition);
					System.out.println(currentDescription);
					Room thisRoom = location[roomId];
					goldAmount+= thisRoom.getGold();
					take(thisRoom);
					thisRoom.nowBeen();
					locationStack = locationTrail(thisRoom.getName(), locationStack);
					locationQueue = locationTrail(thisRoom.getName(), locationQueue);
					System.out.println("LOCATION: " + currentPosition  + "\t SCORE: " + score + "\t YOUR GOLD: " + goldAmount);  //updates user with current location and score info
					}
				}
			if(currentPosition.equals(location[3].getName())) //if the user is in the magic shop (location 3)
			{
				enterShop();
			}
			

		}

		System.out.println("Game over, thanks for playing!");   //lets user know they successfully quit
	}
	
	public static Stack locationTrail(String n, Stack locationStack)
	{
		try {
		locationStack.push(n);
		}
		catch (Exception NullPointerException)
		{
			System.out.println("No valid location");
		}
		return locationStack;
	}
	public static Queue locationTrail(String n, Queue locationQueue)
	{
		try {
			locationQueue.add(n);
		}
		catch (Exception NullPointerException)
		{
			System.out.println("No valid location");
		}
		return locationQueue;
	}

	public static void enterShop()
	{
		inShop = true;  //loop control 
		Scanner storeScan = new Scanner(System.in);
		System.out.print("Would you like to purchase something from the magic shop (Y/N). Or enter 'I' followed by a page number,1-" + pageCount + ", (ex. I34 for page 34) to view whats in stock: ");
		String doYouBuy = " ";
		doYouBuy = storeScan.nextLine();
		if(doYouBuy.length()>0) //making sure user does enter nothing, cause if they do, it breaks
			doYouBuy.substring(0,1);  //takes the first letter because if they enter I and the page number, only interested in the I here
		else
			enterShop();  //user entered nothing, so they are redirected back to the beginning
		while(inShop)
		{
			if(doYouBuy.equalsIgnoreCase("Y"))  //user WANTS to buy items, enters purchasing loop
			{
				System.out.print("\nEnter the name of the item you would like to purchase: ");  
				String itemDesired = storeScan.nextLine();
				buyItem(itemDesired);  //sends the desired item to the buying function
			}
			else if(doYouBuy.equalsIgnoreCase("N"))  
			{
				inShop = false;  //user does not want to buy an item and the while loop is exited
				System.out.println("You now want to leave the shop.");
			}
			else if(doYouBuy.equalsIgnoreCase("I"))  //user wants to view the inventory. This checks for only I, therefore no page and so they go to page 1
			{
				shopInventory(1);  //sends user to page 1 of shop inventory
			}
			else if(doYouBuy.substring(0,1).equalsIgnoreCase("I"))  //user wants to view the shop inventory and specified a page number
			{
				String pageN = doYouBuy.substring(1);  //gets all the info after the I, therefore the page number
				try {
				shopInventory(Integer.parseInt(pageN));  //turns the string into an int so the shop can give right page number
				}
				catch(Exception NumberFormatException) {  //error message if anything but an int is entered
					System.out.println("\nPlease only follow I by a number between 1 and 67 without a space or any other characters.\n");
				}
				finally {
					enterShop();  //something but an int was entered so loop is started over
				}
			}
			else  //user did not enter y or n
			{
				System.out.println("You are not entering valid input. Please only enter 'Y' or 'N'.");
				enterShop();
			}
		}
		//System.out.println();
		//storeScan.close();
	}
	
	public static MagicShopItems searchStore(String itemDesired)
	{
		ArrayList<String> magicNames = new ArrayList<String>();
		for(int i=0; i<magicItems.size(); i++)
		{
			magicNames.add(magicItems.get(i).getName());
		}
		int index = Collections.binarySearch(magicNames, itemDesired);
		if(index<0)
			return null;
		else
			return magicItems.get(index);
		/*for(MagicShopItems elem:magicItems)    //goes through the list of magic items
		{
			if(elem.getName().equalsIgnoreCase(itemDesired))  //if an element is equal to the name of the desired item, element is return
				return elem;
		}
		return null;  //nothing was found, so null is returned */
	}
	
	public static void buyItem(String itemDesired)
	{
		Scanner storeScan = new Scanner(System.in);
		if(searchStore(itemDesired)!=null) //searchStore returns index of item if found. If not found, it returns -999
		{
			if(searchStore(itemDesired).getCost()<=goldAmount)  //if the item is found, the gold amount is checked against users amount
			{
				inventory.add(itemDesired);  //adds item to inventory
				System.out.println("You have successfully purchased " + itemDesired + " for " + searchStore(itemDesired).getCost() + " pieces of gold!");
				goldAmount-=searchStore(itemDesired).getCost();  //user "pays" for the item
				magicItems.remove(searchStore(itemDesired));  //item is removed
				inShop = false;
			}	
			else
			{
				System.out.print("\nYou do not have enough gold to pay for that item. Would you like to search again (Y/N): ");  
				String again = storeScan.nextLine();
				if(again.equalsIgnoreCase("N"))  //user does not want to search again so the loop is breaks
					inShop = false;
			}
		}
		else
		{
			System.out.println();
			System.out.print("We do not have that item in stock. Would you like to search again (Y/N): ");  
			String again = storeScan.nextLine();  
			if(again.equalsIgnoreCase("N"))  //user does want want to continue searching and the loop breaks
				inShop = false;
		}
		//storeScan.close();
	}
	
	
	public static void shopInventory(int n)
	{
		Scanner in = new Scanner(System.in);	
		if(n<=pageCount)  //
		{
			System.out.format("%50s%20s", "ITEM", "COST (Gold Pieces)\n");  //Header and is put in-line with the corresponding info
			int starting = (n-1)*10;                     //takes page number use wants, subtracted by 1 because of indices, then multiplied by 10 because there are 10 values per page and the loop is concerned with values
			for(int i = starting; i<starting+10;i++)
			{
				if(magicItems.size()>i)   //makes sure that the index does not go above the list size
					System.out.format("%50s%20s",magicItems.get(i).getName(), magicItems.get(i).getCost() + "\n");  //prints item name and price aligned under the header
			}
			System.out.println("Page " + n + " of " + pageCount);  //prints page number at the bottom of the list
			System.out.print("Press enter to view next page or anything to leave the menu.");  //tells user how to advance pages or to leave the menu
			String maybeNext = in.nextLine();
			if(maybeNext.equals(""))   //if user presses enter, then the next page is shown
			{	
				if(magicItems.size()>(starting+10))
					shopInventory(n+1);  //runs function again but at the next page
				else
				{
				//	in.close();
					enterShop(); //user wants to advance on the menu but already at the last page so ends the menu
				}
			} 
			else
			{
				//in.close();
				enterShop();  //user doesn't press enter so the inventory is exited and prompted with magicShop commands 
			}
		}
		else
			System.out.println("That is not a valid page");
	}
	
	public static void map() { //prints map
		if(mapFound)
		{
			System.out.println("-------------------------------------------------");
			System.out.println("|                     GYM           AUDITORIUM  |");
			System.out.println("|                      ^                 ^      |");
			System.out.println("|                      |                 |      |");
			System.out.println("|                      v                 v      |");
			System.out.println("|    NURSE   <-->  CLASSROOM   <--> CAFETERIA	|");
			System.out.println("|                      ^                 ^      |");
			System.out.println("|                      |                 |      |");
			System.out.println("|                      v                 v      |");
			System.out.println("| MAGIC SHOP  <-->  LABORATORY  <-->  OFFICE	|");
			System.out.println("-------------------------------------------------");
		}
		else
			System.out.println("The map has not yet been found and cannot be viewed.  Keep searching.");
	}
	
	public static void getInput(String currRoom, String userInput, Queue locationQueue, Stack locationStack) { //determines what to do with user input
		canGo = false; //by default, will not print the walk message
		if ((userInput.equals("n") || userInput.equals("s")|| userInput.equals("e")|| userInput.equals("w")))  //if user enters a direction and monster is summoned, enters if-statement
		{  		
			if(monster==3)  //if the monster random number (1-5) lands on 3 (20% chance), the monster event triggers
			{
				System.out.println("The monster attacked you so you lost 3 points!");  //lets user know monster attacked them
				score -= 3; //lose 3 points for getting randomly attacked
			}
			determineMove(currRoom,userInput);
		}	
		else if (userInput.equals("m"))  //user enters m, map appears
			map();
		else if (userInput.equals("v")) //user enters v, inventory appears
		{
			if(inventory.size()!=0)  //as long as inventory isn't empty, it prints inventory
			{
				for(String item: inventory)  //goes through the inventory arrayList and prints inventory
				{
					System.out.println("\t\u2023" + item);  //prints items
				}
				System.out.println("");
			}
			else
				System.out.println("You have no items in your inventory. Keep searching!");  //lets user know they have no items to view
		}
		else if (userInput.equals("u"))  //user enters u, uses the oldest shop item in inventory
		{
			if(inventory.size()>0)
				{
				if(!inventory.get(0).equals("MAP"))
				{
					score+=5;
					System.out.println("You have used your " + inventory.get(0) + " and have gained 5 points for it!");
					inventory.remove(0);
				}
				else if(inventory.get(0).equals("MAP")) //oldest item is map
				{
					if(inventory.size()==1)  //map is only item in the inventory
					{
						System.out.println("Your only item is the map and it is not consumable.");
					}
					
					if(inventory.size()>=2)
					{
						score+=5;
						System.out.println("You have used your " + inventory.get(1) + " and have gained 5 points for it!");
						inventory.remove(1);
					}
				}
			}
			else
				System.out.println("You do not have any useable items in your inventory! Keep searching!");
		}
		else if (userInput.equalsIgnoreCase("h"))  //user enters h, help menu appears
			System.out.println("Valid commands are:" 
					+ "\n\t"+"\u2022" + "'n' to move character north."
					+ "\n\t"+"\u2022" + "'s' to move character south."
					+ "\n\t"+"\u2022" + "'e' to move character east."
					+ "\n\t"+"\u2022" + "'w' to move character west."
					+ "\n\t"+"\u2022" + "'dance' to dance into a new location."
					+ "\n\t"+"\u2022" + "'skip' to skip(the action) into a new location."
					+ "\n\t"+"\u2022" + "'m' to view the map."
					+ "\n\t"+"\u2022" + "'v' to view your inventory."
					+ "\n\t"+"\u2022" + "'h' to view the help menu."
					+ "\n\t"+"\u2022" + "'u' to use a shop item."
					+ "\n\t"+"\u2022" + "'quit' to quit the game");
		else if (userInput.equalsIgnoreCase("quit"))  //user enters quit, gameLoop get sets to false and gets exited
		{
			gameOn = false;
			Scanner gameEnd = new Scanner(System.in);
			boolean endGame = true;
			while(endGame)
			{
			System.out.print("\n Would you like to view your walkthrough of the hallways 'forwards' or 'backwards'? ");
			String playBack = gameEnd.nextLine();
			if(playBack.substring(0,1).equalsIgnoreCase("f"))
			{
				locationPlayback(locationQueue,locationStack,playBack.substring(0,1));
				endGame = false;
			}
			else if(playBack.substring(0,1).equalsIgnoreCase("b"))
			{
				locationPlayback(locationQueue,locationStack,playBack.substring(0,1));
				endGame = false;
			}
			else
				System.out.println("Please enter only 'forwards' or 'backwards'.");
			}
			System.out.println("Your final score: " + score);
			System.out.println("Your final gold count: " + goldAmount);
			System.out.println("Your inventory: ");
			for(int i=0; i<inventory.size(); i++) {
				System.out.println("\t" + inventory.get(i));
			}
			
			File fileScores = new File("highScores");
			Scanner scoreScanner;
			int highScore;
			try {
				scoreScanner = new Scanner(fileScores);
			for(int i = 0; i<10; i++)
			{
				highScore = scoreScanner.nextInt();
				highScoreList.add(highScore);
			} 
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				PrintWriter writer = new PrintWriter("highScores");
				int k = 0;
				while(k<10)
				{
					if(highScoreList.get(k)<score)
					{
						highScoreList.add(k, score);
						highScoreList.remove(10); //since adding the new score creates an 11th high score instance, we need to delete it to keep the file for the top 10.
						for(int i=0;i<10;i++)
						{
							writer.print(highScoreList.get(i));
							writer.print("\n");
							writer.flush();
						}
						k=11; //breaks loop cause high score was added to right spot
					}
					k++;
				}
				writer.close();
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			System.out.print("Would you like to view the updated high scores list (Y/N)?");
			String viewScores = gameEnd.nextLine();
			if(viewScores.equalsIgnoreCase("y"))
			{
				for(int i=0; i<10; i++)
				{
					System.out.println(highScoreList.get(i));
				}
			}
		}
		
		else  //if no valid input is given, prints error message and reprompts user to enter a command
			System.out.println("You did not enter a valid input"); 
	}
	
	public static void locationPlayback(Queue locationQueue, Stack locationStack, String n)
	{
		if(n.equals("f"))
		{
			while(locationQueue.peek()!=null)
			{	
				try
			{
				System.out.println(locationQueue.poll());  //prints the value atop the list
			}
			catch (Exception NoSuchElementException)  //exception thrown if queue is empty
			{
				System.out.println("This was your route.");  //lets user know the queue is empty
			}
			}
		}
		else
		{
			while(!locationStack.isEmpty())
			{	
				try
			{
				System.out.println(locationStack.pop());  //prints the value atop the list
			}
			catch (Exception EmptyCollectionException)  //exception thrown if queue is empty
			{
				System.out.println("This was your route.");  //lets user know the queue is empty
			}
			}
		}
	}
	

	public static void take(Room currRoom)
	{
		Scanner doYouWant = new Scanner(System.in);
		boolean tempBoolean = false;
		if(currRoom.hasItems())
			 tempBoolean = true;
		else
			System.out.println("There are no items in this room.");
		while(tempBoolean)
		{
				System.out.println("In this room, there is " + currRoom.getItem(0) + ".");
				System.out.print("Would you like to take the item found? (Y/N)");
				String ans = doYouWant.nextLine();
				if(ans.equalsIgnoreCase("y"))
				{
					inventory.add(currRoom.getItem(0));
					if(currRoom.getItem(0).equalsIgnoreCase("map"))    //if the item is the map, map is now avaiable for use
					{
						mapFound = true;  //boolean that controls if map can be viewed
					}
					currRoom.removeItem();
					System.out.println("ITEM ACQUIRED!");  //lets user know the successfully picked up an item
					tempBoolean = false;
				}
				else if(ans.equalsIgnoreCase("n"))
				{
					tempBoolean = false; //exits questioning loop
				}
				else
					System.out.println("You are not entering valid input. Please type 'y'or 'n '");		
		}
		//doYouWant.close();
	}
	
	public static void determineMove(String currRoom, String userInput)
	{
		if (userInput.equalsIgnoreCase("n")) //user enters n for north
		{
			if(currentPosition.equals(location[0].getName()))	//can go from lab (0) to classroom (1)
			{
				currentPosition = location[1].getName();  //moves to classroom 
				currentDescription = location[1].getDescription(); //sets description
				roomId = 1;
				score+=location[1].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[1].getName()))	//can go from classroom (1) to gym (2)
			{
				currentPosition = location[2].getName();  //moves to gym
				currentDescription = location[2].getDescription(); //sets description
				roomId = 2;
				score+=location[2].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[3].getName()))	//can go from magic shop (3) to nurse (4)
			{
				currentPosition = location[4].getName();  //moves to nurse
				currentDescription = location[4].getDescription(); //sets description
				roomId = 4;
				score+=location[4].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[5].getName()))	 //can go from office (5) to cafeteria (6)
			{
				currentPosition = location[6].getName();  //moves to cafeteria
				currentDescription = location[6].getDescription(); //sets description
				roomId = 6;
				score+=location[6].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[6].getName()))	//can go from cafeteria (6) to auditorium (7)
			{
				currentPosition = location[7].getName();  //moves to auditorium
				currentDescription = location[7].getDescription(); //sets description
				roomId = 7;
				score+=location[7].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else
				System.out.println("You cannot go in that direction. Please choose another direction or enter 'm' for a map"); //when cannot advance in desired direction
		}
		else if (userInput.equals("s"))   //user enters s for south
		{
			if(currentPosition.equals(location[1].getName()))	//can go from classroom (1) to lab (0)
			{
				currentPosition = location[0].getName();  //moves to lab
				currentDescription = location[0].getDescription(); //sets description
				roomId = 0;
				score+=location[0].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[2].getName()))	//can go from gym (2) to classroom (1)
			{
				currentPosition = location[1].getName();  //moves to classroom
				currentDescription = location[1].getDescription(); //sets description
				roomId = 1;
				score+=location[1].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[4].getName()))	//can go from nurse (4) to magic shop (3)
			{
				currentPosition = location[3].getName();  //moves to magic shop
				currentDescription = location[3].getDescription(); //sets description
				roomId = 3;
				score+=location[3].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[6].getName()))	//can go from cafeteria (6) to office (5)
			{
				currentPosition = location[5].getName();  //moves to office
				currentDescription = location[5].getDescription(); //sets description
				roomId = 5;
				score+=location[5].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[7].getName()))	//can go from auditorium (7) to cafeteria (6)
			{
				currentPosition = location[6].getName();    //moves to cafeteria
				currentDescription = location[6].getDescription(); //sets description
				roomId = 6;
				score+=location[6].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else
				System.out.println("You cannot go in that direction. Please choose another direction or enter 'm' for a map");  //when cannot advance in desired direction
		}
		else if(userInput.equals("e"))  //user enters e for east
		{	
			if(currentPosition.equals(location[0].getName()))	//can go from lab (0) to office (5)
			{
				currentPosition = location[5].getName();   //moves to office
				currentDescription = location[5].getDescription(); //sets description
				roomId = 5;
				score+=location[5].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[1].getName()))	//can go from classroom (1) to cafeteria (6)
			{
				currentPosition = location[6].getName();   //moves to cafeteria
				currentDescription = location[6].getDescription(); //sets description
				roomId = 6;
				score+=location[6].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[2].getName()))	//can go from gym (2) to auditorium(7)
			{
				currentPosition = location[7].getName();  //moves to auditorium
				currentDescription = location[7].getDescription(); //sets description
				roomId = 7;
				score+=location[7].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[3].getName()))	//can go from magic shop (3) to lab(0)
			{
				currentPosition = location[0].getName();   //moves to lab
				currentDescription = location[0].getDescription(); //sets description
				roomId = 0;
				score+=location[0].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[4].getName()))	//can go from nurse (4) to classroom (1)
			{
				currentPosition = location[1].getName();   //moves to classroom
				currentDescription = location[1].getDescription(); //sets description
				roomId = 1;
				score+=location[1].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else
				System.out.println("You cannot go in that direction. Please choose another direction or enter 'm' for a map"); //when cannot advance in desired direction
		}
		else if(userInput.equals("w"))  //user enters w for west
		{
			if(currentPosition.equals(location[0].getName()))	//can go from lab (0) to magic shop (3)
			{
				currentPosition = location[3].getName();   //moves to magic shop
				currentDescription = location[3].getDescription(); //sets description
				roomId = 3;
				score+=location[3].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[1].getName()))	//can go from classroom (1) to nurse (4)
			{
				currentPosition = location[4].getName();  //moves to nurse
				currentDescription = location[4].getDescription(); //sets description
				roomId = 4;
				score+=location[4].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[5].getName()))	//can go from office (5) to lab(0)
			{
				currentPosition = location[0].getName();  //moves to lab
				currentDescription = location[0].getDescription(); //sets description
				roomId = 0;
				score+=location[0].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[6].getName()))	//can go from cafeteria (6) to classroom (1)
			{
				currentPosition = location[1].getName();  //moves to classroom
				currentDescription = location[1].getDescription(); //sets description
				roomId = 1;
				score+=location[1].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else if(currentPosition.equals(location[7].getName()))	//can go from auditorium (7) to gym (2)
			{
				currentPosition = location[2].getName();  //moves to gym
				currentDescription = location[2].getDescription(); //sets description
				roomId = 2;
				score+=location[2].getPoints(); //adds location's points to the player's score
				canGo = true;
			}
			else
				System.out.println("You cannot go in that direction. Please choose another direction or enter 'm' for a map"); //when cannot advance in desired direction
		}
}		
}
