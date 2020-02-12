ATTACH_FROM_CSV('demo.openbeer.styles','../vad/openbeerdb/styles.csv' ,',', '\n', null, 1, vector(1)) ;
ATTACH_FROM_CSV('demo.openbeer.categories','../vad/openbeerdb/categories.csv' ,',', '\n', null, 1, vector(1)) ;
ATTACH_FROM_CSV('demo.openbeer.breweries','../vad/openbeerdb/breweries.csv' ,',', '\n', null, 1, vector(1)) ;
ATTACH_FROM_CSV('demo.openbeer.breweries_geocode','../vad/openbeerdb/breweries_geocode.csv' ,',', '\n', null, 1, vector(1)) ;

DROP TABLE demo.openbeer.beers;
ATTACH_FROM_CSV('demo.openbeer.beers','../vad/openbeerdb/beers.csv' ,',', '\n', null, 1, vector(1)) ;


SPARQL
prefix openbeer-schema: <http://localhost:8890/schemas/openbeerdb/>
prefix openbeer: <https://openbeerdb.com/ontology#>

INSERT INTO <urn:openbeer:data> {?styleIRI a rdfs:Class, openbeer:Style; <https://openbeerdb.com/ontology#hasCategory> ?categoryIRI;  rdfs:label ?label.}
WHERE
{
SELECT  
IRI(CONCAT("https://openbeerdb.com/ontology#",replace(replace(str(?s),".*id/",""),"#this",""))) as ?styleIRI 
IRI(CONCAT("https://openbeerdb.com/ontology#category-",?categoryID)) as ?categoryIRI
?label
WHERE 
{
?s a openbeer-schema:styles;
openbeer-schema:id ?id;
openbeer-schema:cat_id ?categoryID;
openbeer-schema:style_name ?label.

}

};

SPARQL 
prefix openbeer-schema: <http://localhost:8890/schemas/openbeerdb/>
prefix openbeer: <https://openbeerdb.com/ontology#>

INSERT INTO <urn:openbeer:data> {?categoryIRI a rdfs:Class, openbeer:Category;rdfs:label ?label.}
WHERE
{
SELECT  
IRI(CONCAT("https://openbeerdb.com/ontology#category-",?categoryID)) as ?categoryIRI
?label
WHERE 
{
?s a openbeer-schema:categories;
openbeer-schema:id ?categoryID;
openbeer-schema:cat_name ?label.

}

};

SPARQL

prefix openbeer-schema: <http://localhost:8890/schemas/openbeerdb/>

SELECT  
IRI(CONCAT("https://openbeerdb.com/brewery/",?breweryID,"#this")) as ?breweryID
?label
?address1
replace(?address2,'""',"") as ?address2
replace(?city,'""',"") as ?city
IRI(CONCAT("https://openbeerdb.com/city/",replace(?city,'""',""),"#this")) as ?cityIRI
replace(?state,'""',"") as ?state
IRI(CONCAT("https://openbeerdb.com/state/",replace(?state,'""',""),"#this")) as ?stateIRI
?postcode
IRI(if(strlen(?phone) > 0,CONCAT("tel:",?phone),"")) as ?phoneIRI
IRI(?site) as ?siteIRI
replace(?description,'""',"") as ?description

WHERE 
{
?s a openbeer-schema:breweries;
openbeer-schema:id ?breweryID;
openbeer-schema:name ?label;
openbeer-schema:address1 ?address1;
openbeer-schema:address2 ?address2;
openbeer-schema:city ?city;
openbeer-schema:code ?postcode;
openbeer-schema:country ?country;
openbeer-schema:phone ?phone;
openbeer-schema:website ?site;
openbeer-schema:descript ?description.
OPTIONAL{ ?s openbeer-schema:state ?state}.

};

SPARQL
prefix openbeer-schema: <http://localhost:8890/schemas/openbeerdb/>
prefix openbeer: <https://openbeerdb.com/ontology#>


INSERT INTO <urn:openbeer:data>{
?breweryIRI 
 a openbeer:Brewery; 
 rdfs:label ?label; openbeer:address 
 ?address1; 
 openbeer:city ?cityIRI; 
 openbeer:state ?stateIRI; 
 openbeer:country ?countryIRI;
 openbeer:postcode ?postcode; 
 openbeer:phone ?phoneIRI; 
 schema:site ?siteIRI; 
 rdfs:comment ?descriptionText. 

?cityIRI 
 a openbeer:City;
 rdfs:label ?cityLabel.

?stateIRI 
 a openbeer:State;
 rdfs:label ?stateLabel.

 ?countryIRI a openbeer:Country;
 rdfs:label ?countryLabel.

}
WHERE
{
SELECT  
IRI(CONCAT("https://openbeerdb.com/brewery/",?breweryID,"#this")) as ?breweryIRI
?label
?address1
replace(?city,'""',"") as ?cityLabel
IRI(CONCAT("https://openbeerdb.com/city/",replace(replace(?city,'""',"")," ",""),"#this")) as ?cityIRI
replace(?state,'""',"") as ?stateLabel
IRI(CONCAT("https://openbeerdb.com/state/",replace(replace(?state,'""',"")," ",""),"#this")) as ?stateIRI
replace(?country,'""',"") as ?countryLabel
IRI(CONCAT("https://openbeerdb.com/country/",replace(replace(?country,'""',"")," ",""),"#this")) as ?countryIRI

?postcode
IRI(if(strlen(?phone) > 0,CONCAT("tel:",?phone),"")) as ?phoneIRI
IRI(?site) as ?siteIRI
replace(?description,'""',"") as ?descriptionText

WHERE 
{
?s a openbeer-schema:breweries;
openbeer-schema:id ?breweryID;
openbeer-schema:name ?label;
openbeer-schema:address1 ?address1;
openbeer-schema:city ?city;
openbeer-schema:code ?postcode;
openbeer-schema:country ?country;
openbeer-schema:phone ?phone;
openbeer-schema:website ?site;
openbeer-schema:descript ?description.
OPTIONAL{ ?s openbeer-schema:state ?state}.

}
}