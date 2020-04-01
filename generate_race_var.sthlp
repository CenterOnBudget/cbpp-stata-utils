{smcl}

{title:Title}

{p 4 4 2}
{bf:generate_race_var} {hline 2} Generate categorical race-ethnicity variable for CPS or ACS microdata.



{title:Description}

{p 4 4 2}
{bf:generate_race_var} generates a categorial variable for race-ethnicity. It can be used with CPS or ACS microdata. Users may specify the desired number of levels: 2, 4, 5-7 for CPS and 2, 4, 5-7 for ACS.



{title:Syntax}

{p 4 4 2}
{bf:generate_race_var} {it:{help newvar}}, {bf:categories({it:integer})} {bf:dataset({it:string})} [{it:options}]


{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Required}
	{synopt:{opt cat:egories(integer)}}number of values for the categorical variable to be generated.{p_end}
	{synopt:{opt data:set(string)}}CPS or ACS (case insensitive).{p_end}
	
{syntab:Optional}
    {synopt:{opt no_label}}{it:newvar} will not be labelled.{p_end}
    {synopt:{opt replace}}{it:newvar} will be replaced if it exists.{p_end}



{title:Category Definitions / Labels}

{p2colset 4 22 22 2}
{p2col:{bf}categories({it:2}){sf}}1 	White Non-Hisp.
{break}    								  2 	Not White Non-Hisp.{p_end}

{p2col:{bf}categories({it:4}){sf}}1 	White Non-Hisp.		
{break}    								  2 	Black Non-Hisp.
{break}    								  3 	Hispanic (of any race)
{break}    								  4 	Another Race or Mult. Races Non-Hisp.{p_end}

{p2col:{bf}categories({it:5}){sf}}1 	White Non-Hisp.		
{break}    								  2 	Black Non-Hisp.
{break}    								  3 	Hispanic (of any race)
{break}    								  4		Asian Non-Hisp.
{break}    								  5 	Another Race or Mult. Races Non-Hisp.{p_end}

{p2col:{bf}categories({it:6}){sf}}1 	White Non-Hisp.		
{break}    								  2 	Black Non-Hisp.
{break}    								  3 	Hispanic (of any race)
{break}    								  4		Asian Non-Hisp.
{break}    								  5 	AIAN Non-Hisp.
{break}    								  6 	Another Race or Mult. Races Non-Hisp.{p_end}

{p2col:{bf}categories({it:7}){sf}}1 	White Non-Hisp.		
{break}    								  2 	Black Non-Hisp.
{break}    								  3 	Hispanic (of any race)
{break}    								  4		Asian Non-Hisp.
{break}    								  5 	AIAN Non-Hisp.
{break}    								  6 	NHOPI Non-Hisp.
{break}    								  7 	 {bf:ACS:} Another Race or Mult. Races Non-Hisp 
{break}    								  7		 {bf:CPS:} Mult. Races Non-Hisp.{p_end}

{p2col:{bf}categories({it:8}){sf}}1 	White Non-Hisp.{p_end}
{p2col:{it:ACS only}}2 	Black Non-Hisp.
{break}    								  3 	Hispanic (of any race)
{break}    								  4		Asian Non-Hisp.
{break}    								  5 	AIAN Non-Hisp.
{break}    								  6 	NHOPI Non-Hisp.
{break}    								  7 	Some Other Race Non-Hisp 
{break}    								  8		Mutliple Races{p_end}
{p2colreset}{...}
	

{title:Example(s)}

{space 3}Generate a 5-category race-ethnicity variable named "race_5" for ACS microdata.
        {bf:. generate_race_var race_5, categories(5) dataset(acs)}

    Generate an unlabeled 2-category (person of color/white non-Hispanic) race-ethnicity variable for CPS microdata.
        {bf:. generate_race_var person_of_color, categories(2) dataset(cps) no_label}

		

{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


