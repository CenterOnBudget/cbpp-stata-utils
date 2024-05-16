{smcl}

{title:Title}

{p 4 4 2}
{bf:generate_race_var} {hline 2} Generate a race-ethnicity variable in ACS or CPS microdata.



{title:Description}

{p 4 4 2}
{bf:generate_race_var} generates a categorical variable for race-ethnicity in ACS
or CPS microdata.

{p 4 4 2}
Users may specify the desired number of categories for the new variable; see 
{help generate_race_var##categories:Categories and Labels}.

{p 4 4 2}
In ACS microdata, the variables {bf:rac1p} and {bf:hisp} must exist. In CPS 
microdata, the variables {bf:prdtrace} and {bf:pehspnon} must exist.



{title:Syntax}

{p 4 4 2}
{bf:generate_race_var} {newvar}, {opt data:set(acs|cps)} {opt cat:egories(integer)} [{it:options}]


{synoptset 22}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opt data:set(string)}}The type of dataset in memory; ACS or CPS (case insensitive).{p_end}
{space 2}{synopt:{opt cat:egories(integer)}}Number of categories for newvar. With {opt dataset(acs)}, up to 8. With {opt dataset(cps)}, up to 7. See {help generate_race_var##categories:Categories and Labels}.{p_end}
{space 2}{synopt:{opt nolab:el}}Do not assign value labels to newvar {it:newvar}.{p_end}
{synoptline}


{marker categories}{...}

{title:Categories and Labels}

{p2colset 4 22 22 2}
{p2col:{bf}categories({it:2}){sf}}
{break}      1   White, not Latino
{break}      2   Not White, not Latino{p_end}

{p2col:{bf}categories({it:4}){sf}}
{break}      1   White, not Latino      {break}
{break}      2   Black, not Latino
{break}      3   Latino (of any race)
{break}      4   Another Race or Mult. Races, not Latino{p_end}

{p2col:{bf}categories({it:5}){sf}}
{break}      1   White, not Latino      {break}
{break}      2   Black, not Latino
{break}      3   Latino (of any race)
{break}      4   Asian, not Latino
{break}      5   Another Race or Mult. Races, not Latino{p_end}

{p2col:{bf}categories({it:6}){sf}}
{break}      1   White, not Latino      {break}
{break}      2   Black, not Latino
{break}      3   Latino (of any race)
{break}      4   Asian, not Latino
{break}      5   AIAN, not Latino
{break}      6   Another Race or Mult. Races, not Latino{p_end}

{p2col:{bf}categories({it:7}){sf}}
{break}      1   White, not Latino      {break}
{break}      2   Black, not Latino
{break}      3   Latino (of any race)
{break}      4   Asian, not Latino
{break}      5   AIAN, not Latino
{break}      6   NHOPI, not Latino
{break}      7   {bf:ACS:} Another Race or Mult. Races, not Latino 
{break}      7   {bf:CPS:} Mult. Races, not Latino{p_end}

{p2col:{bf}categories({it:8}){sf}}{it:ACS only}
{break}      1   White, not Latino
{break}      2   Black, not Latino
{break}      3   Latino (of any race)
{break}      4   Asian, not Latino
{break}      5   AIAN, not Latino
{break}      6   NHOPI, not Latino
{break}      7   Some Other Race, not Latino 
{break}      8    Mutliple Races{p_end}
{p2colreset}{...}



{title:Example(s)}

{space 3}Generate a 5-category race-ethnicity variable in ACS microdata.

        {bf:. generate_race_var race_5, categories(5) dataset(acs)}

    Generate an unlabeled 2-category race-ethnicity variable in CPS microdata.

        {bf:. generate_race_var person_of_color, categories(2) dataset(cps) nolabel}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




