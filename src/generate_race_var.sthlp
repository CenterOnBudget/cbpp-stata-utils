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
{space 2}{synopt:{opt nolab:el}}Do not assign value labels to {it:newvar}.{p_end}
{synoptline}


{marker categories}{...}

{title:Categories and Labels}

{p2colset 6 20 20 2}
{p2col:{bf:Categories}}{bf:Values and Labels}{p_end}
{p2line}
{p2coldent:2}1{space 4}White, not Latino
{break}      2{space 4}Another race or multiracial
{p_end}
{p2line}
{p2coldent:4}1{space 4}White, not Latino      {break}
{break}      2{space 4}Black, not Latino
{break}      3{space 4}Latino (of any race)
{break}      4{space 4}Another race or multiracial, not Latino
{p_end}
{p2line}
{p2coldent:6}1{space 4}White, not Latino      {break}
{break}      2{space 4}Black, not Latino
{break}      3{space 4}Latino (of any race)
{break}      4{space 4}Asian, not Latino
{break}      5{space 4}Another race or multiracial, not Latino
{p_end}
{p2line}
{p2coldent:6}1{space 4}White, not Latino      {break}
{break}      2{space 4}Black, not Latino
{break}      3{space 4}Latino (of any race)
{break}      4{space 4}Asian, not Latino
{break}      5{space 4}American Indian or Alaska Native, not Latino
{break}      6{space 4}Another race or multiracial, not Latino
{p_end}
{p2line}
{p2coldent:7 (ACS)}1{space 4}White, not Latino      {break}
{break}      2{space 4}Black, not Latino
{break}      3{space 4}Latino (of any race)
{break}      4{space 4}Asian, not Latino
{break}      5{space 4}American Indian or Alaska Native, not Latino
{break}      6{space 4}Native Hawaiian or Pacific Islander, not Latino
{break}      7{space 4}Another race or multiracial, not Latino
{p_end}
{p2line}
{p2coldent:7 (CPS)}1{space 4}White, not Latino      {break}
{break}      2{space 4}Black, not Latino
{break}      3{space 4}Latino (of any race)
{break}      4{space 4}Asian, not Latino
{break}      5{space 4}American Indian or Alaska Native, not Latino
{break}      6{space 4}Native Hawaiian or Pacific Islander, not Latino
{break}      7{space 4}Multiracial, not Latino
{p_end}
{p2line}
{p2coldent:8 (ACS only)}1{space 4}White, not Latino
{break}      2{space 4}Black, not Latino
{break}      3{space 4}Latino (of any race)
{break}      4{space 4}Asian, not Latino
{break}      5{space 4}American Indian or Alaska Native, not Latino
{break}      6{space 4}Native Hawaiian or Pacific Islander, not Latino
{break}      7{space 4}Another race, not Latino 
{break}      8{space 4}Multiracial, not Latino
{p_end}
{p2line}


{title:Example(s)}

{space 3}Generate a 5-category race-ethnicity variable in ACS microdata.

        {bf:. generate_race_var race_5, categories(5) dataset(acs)}

    Generate an unlabeled 2-category race-ethnicity variable in CPS microdata.

        {bf:. generate_race_var person_of_color, categories(2) dataset(cps) nolabel}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




