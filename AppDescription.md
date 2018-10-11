About the Armed Conflict Events Dashboard Application
-----------------------------------------------------
#### created by [Soomin Park](mailto:spark13@worldbank.org) 
***

### 1. Purpose
Armed conflict is a major cause of injury and death worldwide: it obviously causes deaths and injuries on the battlefield, but also health consequences from the displacement of populations, the breakdown of health and social services, and the heightened risk of disease transmission, as well as the food insecurity or famine from the undermined agricultural production and the disrupted livelihoods and trade. Those who live in currently conflict-affected countries, such as South Sudan, Yemen, Somalia and Nigeria, face worsening food insecurity primarily as a byproduct of internal civil wars.

This application and the dashboard are created to show the global armed conflict events pattern and trends, for researchers or anyone who are interested in when/where/how/by whom the violent conflict events happened globally.  

### 2. Data
The main source of the data used for this application is [Armed Conflict Location & Event Data Project (ACLED)](https://www.acleddata.com/data/), one of the most widely recognized real-time media-based database on political violence and protest events across the developing world.  

The ACLED dataset used (*Updated on 7/21/2018 - 374,340 events*) is for Africa (1997-current), Middle East/Asia (2016-current), and South/South East Asia (2010(varies by countries)-current)), and contains more than 370K events as well as the detailed information about each of the events. The type of the event information included in the data is as below: 
-   Event date (when the event happened)
-   [Event type](#event-type) (type of violence (what happened): Violence against civilians, Remote violence, Riots/Protests, etc.)
-   [Actors](#actor-type)  (who is involved)
-   Location (where the event happened)
	- Region/Country/Admin1,2,3/location/Geo-code(latitude, longitude)
-   Base media source (where the event information is from)

The second dataset used for the conflict impact analysis contains socio-economic indices which are from [the World Bank development data bank](https://data.worldbank.org/).  

### 3. Dashboard ('Dashboard' tab)
The dashboard in this application displays the global armed conflict events pattern and trends. The functions and the graphs in the dashboard are briefly described below: 

#### 3.1. Filters
Select the region/country/Event type/Actor type/Dates/Fatalities level of interest. The entire dashboard is affected by this selection. Click the 'submit' button to activate the dashboard.

#### 3.2. Map
The circles shown on the map shows number of events (circle sizes) and total fatalities (circle colors) happened in the locations on the selected regions/countries during the selected period. 

#### 3.3. Trend chart
The charts show the trends of number of events/fatalities by [event type](#event-type) and [actor type](#actor-type). 

#### 3.4. Top actor type/actors chart
These charts show which actor types/actors were active in terms of number of events/fatalities in the selected locations during the selected period.

#### 3.5. Event types/Detailed Event Types chart
These charts show the proportion of the event types in terms of number of events/fatalities and the detailed event types for each of the event type.

#### 3.6. Interaction (which actors are associated)
The bar graphs show the frequency and the fatality number for each [interaction type](#interaction-type). From these charts you can see which interaction types are happened most/least frequently as well as how different the fatality numbers are for each of the interation types. The mosaic plot displays the magnitude (number of events) of the interaction between both actors at a glance. 

### 4. 'Impact Analysis' tab 
This section is for analysis about the impact of the conflicts on each country's system and economy by looking at the pattern between number of the conflicts happened in each country and various socio-economic factors.  
The functions and the graphs in the 'Dashboard' tab in this application are briefly described below: 

### 5. Terminology
Below is the descriptions of the concepts that are mainly used in this application, such as event types, actor types, and interaction types (source: [ACLED Codebook](https://www.acleddata.com/download/2827/)). For more information and/or more detail, check the code book as well as the [General Guides page](https://www.acleddata.com/resources/general-guides/) on the ACLED website. 
  
#### 5.1. Event type <a name="event-type"></a>
<a href="https://drive.google.com/uc?export=view&id=1VXXxchejEmrIC8lncnOmkVwfd4miqkyn"><img src="https://drive.google.com/uc?export=view&id=1VXXxchejEmrIC8lncnOmkVwfd4miqkyn" style="width: auto; height: auto" title="Click for the larger version." /></a>
<a href="https://drive.google.com/uc?export=view&id=1nJOR3YjiAzIWZ-l6mNki9-QY5vBOibiH"><img src="https://drive.google.com/uc?export=view&id=1nJOR3YjiAzIWZ-l6mNki9-QY5vBOibiH" style="width: auto; height: auto" title="Click for the larger version." /></a>

#### 5.2. Actor types <a name="actor-type"></a>
- **Code 1: Governments and State Security Services**
Governments are defined as internationally recognized regimes in assumed control of a state. 
- **Code 2: Rebel Groups**
Rebel groups are defined as political organizations whose goal is to counter an established national governing regime by violent acts. 
- **Code 3: Political Militias**
Political militias are a more diverse set of violent actors, who are often created for a specific purpose or during a specific time period (i.e. Janjaweed) and for the furtherance of a political purpose by violence.
- **Code 4: Identity Militias**
ACLED includes a broad category of “identity militias” that signifies armed and violent groups organized around a collective, common feature including community, ethnicity, region, religion or, in exceptional cases, livelihood.
- **Code 5: Rioters**
Rioters are individuals who either engage in violence during demonstrations or in spontaneous acts of disorganised violence, and are noted by a general category of “Rioters (Country)”.
- **Code 6: Protesters**
Protesters are individuals who do not engage in violence during demonstrations, and are noted by a general category of “Protesters (Country)”; if a group is affiliated or leading an event (e.g. MDC political party), the associated group is named in the respective associated actor category. Although protesters are nonviolent, they may be the targets of violence by other groups (e.g. security institutions, private security firms, or other armed actors).
- **Code 7: Civilians**
Civilians, in whatever number or association, are victims of violent acts within ACLED as they are, by definition, unarmed and, hence, vulnerable.
- **Code 8: External/Other Forces**
Small categories of “other” actors include hired mercenaries, private security firms and their employees, United Nations or external forces. They are noted by their name and actions. The military forces of states are coded as ‘other’ when active outside of their home state (e.g. the military of Kenya active in Somalia).

#### 5.3. Interaction types <a name="interaction-type"></a>
(*Note: The interaction code (e.g. 10, 11, 12...) is the combination of the actor type codes.*) 

- 10- SOLE MILITARY ACTION (e.g. base establishment by state forces; remote violence involving state military with no reported casualties; non-violent military operations)
- 11- MILITARY VERSUS MILITARY (e.g. military in-fighting; battles between a military and mutinous forces; arrests of military officials)
- 12- MILITARY VERSUS REBELS (e.g. civil war violence between state forces and a rebel actor)
- 13- MILITARY VERSUS POLITICAL MILITIA (e.g. violence between state forces and unidentified armed groups; violence between police and political party militias)
- 14- MILITARY VERSUS COMMUNAL MILITIA (e.g. military engagement with a communal militia; police engagement with a vigilante militia)
- 15- MILITARY VERSUS RIOTERS (e.g. suppression of a demonstration by police or military)
- 16- MILITARY VERSUS PROTESTERS (e.g. suppression of a demonstration by police or military)
- 17- MILITARY VERSUS CIVILIANS (e.g. state repression of civilians; arrests by police)
- 18- MILITARY VERSUS OTHER (e.g. inter-state conflict; state engagement with private security forces or a UN operation; strategic developments between a regime and the UN or another external actor)
- 20- SOLE REBEL ACTION (e.g. base establishment; remote violence involving rebel groups with no reported casualties; accidental detonation by a rebel group)
- 22- REBELS VERSUS REBELS (e.g. rebel in-fighting; violence between rebel groups and their splinter movements)
- 23- REBELS VERSUS POLITICAL MILIITA (e.g. civil war violence between rebels and a pro-government militia; violence between rebels and unidentified armed groups)
- 24- REBELS VERSUS COMMUNAL MILITIA (e.g. violence between rebels and vigilante militias or other local security providers)
- 25- REBELS VERSUS RIOTERS (e.g. spontaneous violence against a rebel group ; a violent demonstration engaging a rebel group) 
- 26- REBELS VERSUS PROTESTERS (e.g. violence against protesters by rebels)
- 27- REBELS VERSUS CIVILIANS (e.g. rebel targeting of civilians [a strategy commonly used in civil war])
- 28- REBELS VERSUS OTHERS (e.g. civil war violence between rebels and an allied state military; rebel violence against a UN operation)
- 30- SOLE POLITICAL MILITIA ACTION (e.g. remote violence by an unidentified armed group with no reported casualties; accidental detonation by a political militia; strategic arson as intimidation by a political party)
- 33- POLITICAL MILITIA VERSUS POLITICAL MILITIA (e.g. inter-elite violence)
- 34- POLITICAL MILITIA VERSUS COMMUNAL MILITIA (e.g violence between communal militia and an unidentified armed group ; violence between political militia and vigilante militias or other local security providers)
- 35- POLITICAL MILITIA VERSUS RIOTERS (e.g. violent demonstration against a political party; spontaneous violence against a political party)
- 36- POLITICAL MILITIA VERSUS PROTESTERS (e.g. peaceful demonstration engaging a political party)
- 37- POLITICAL MILITIA VERSUS CIVILIANS (e.g. out-sourced state repression carried
out by pro-government militias; civilian targeting by political militias or unidentified armed groups)

