//%attributes = {}
$null:=ds:C1482.People.query("age == null")
$notNull:=ds:C1482.People.query("age != null")



If (False:C215)
	
	TRUNCATE TABLE:C1051([People:1])
	SET DATABASE PARAMETER:C642([People:1]; Table sequence number:K37:31; 0)
	
	var $e : cs:C1710.PeopleEntity
	
	$bottom:=!1948-01-01!
	$range:=Current date:C33-$bottom
	
	For ($i; 1; 10000)
		$e:=ds:C1482.People.new()
		$e.dateOfBirth:=Add to date:C393($bottom; 0; 0; Random:C100%$range)
		$e.save()
	End for 
	
End if 

var $person : cs:C1710.PeopleEntity
$youngFirst:=ds:C1482.People.all().orderBy("yearOfBirth desc")
$youngLast:=ds:C1482.People.all().orderBy("yearOfBirth asc")
$youngFirst:=ds:C1482.People.all().orderBy("age asc")
$youngLast:=ds:C1482.People.all().orderBy("age desc")

$seventyToday:=ds:C1482.People.query("age === :1"; 70)
$seventy:=ds:C1482.People.query("age == :1"; 70)
$seventyAndOver:=ds:C1482.People.query("age >= :1"; 70).distinct("age")
$twentyAndUnder:=ds:C1482.People.query("age <= :1"; 20).distinct("age")
$overSeventy:=ds:C1482.People.query("age > :1"; 70).distinct("age")
$underTwenty:=ds:C1482.People.query("age < :1"; 20).distinct("age")

$born1974:=ds:C1482.People.query("yearOfBirth === :1"; 1974).distinct("yearOfBirth")
$bornBefore1964:=ds:C1482.People.query("yearOfBirth < :1"; 1964).distinct("yearOfBirth")
$born1964OrEarlier:=ds:C1482.People.query("yearOfBirth <= :1"; 1964).distinct("yearOfBirth")
$born2001OrLater:=ds:C1482.People.query("yearOfBirth >= :1"; 2001).distinct("yearOfBirth")
