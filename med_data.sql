use med
go

/*************
* STAGE DATA *
*************/

create table #providers (
	NPI bigint
	,IsProvider bit
	,StatusCode varchar(25)
	,FirstName varchar(255)
	,LastName varchar(255)
	,DateOfBirth date
	,StartDate date
	,TermDate date
	,Institution varchar(255)
	,Degree varchar(255)
	,Email1 varchar(255)
	,Email2 varchar(255)
	,AreaCode1 int
	,PhoneNumber1 int
	,AreaCode2 int
	,PhoneNumber2 int
);

insert into #providers (StatusCode,FirstName,LastName,DateOfBirth,StartDate,TermDate,Institution,Degree,Email1,Email2,NPI,IsProvider,AreaCode1,PhoneNumber1,AreaCode2,PhoneNumber2) values
	('INACTIVE', 'Sarah', 'Baker', '1973-11-21', '2021-12-03', '2022-02-15', 'University at Buffalo SUNY', 'MD', 'Sarah_Baker7769@network.med', 'Sarah_Baker5730@naiker.biz', 3841813, 1, 621, 8423184, 433, 6051060)
	,('ACTIVE', 'Carol', 'Benfield', '1970-05-10', '2018-11-11', null, 'Washington University in St. Louis', 'MD', 'Carol_Benfield5258@network.med', null, 4841890, 1, 727, 5213642, null, null)
	,('ACTIVE', 'Kurt', 'Butler', '1976-10-27', '2018-10-10', null, 'Johns Hopkins University', 'MD', 'Kurt_Butler7464@network.med', null, 317440, 1, 761, 4721527, null, null)
	,('ACTIVE', 'Ethan', 'Crawley', '1991-11-18', '2021-07-12', null, 'North Carolina State University', 'MD', 'Ethan_Crawley109@network.med', null, 1877404, 1, 777, 3278715, null, null)
	,('ACTIVE', 'Jacqueline', 'Dixon', '1960-02-23', '2021-10-09', null, 'Boston University', 'MD', 'Jacqueline_Dixon6447@network.med', null, 8147083, 1, 148, 2884272, null, null)
	,('INACTIVE', 'Colleen', 'Emmett', '1968-04-15', '2021-04-13', '2022-01-22', 'University of Miami', 'DMD', 'Colleen_Emmett7665@network.med', 'Colleen_Emmett1720@infotech44.tech', 8668955, 1, 366, 6325837, 223, 2842012)
	,('ACTIVE', 'Rick', 'Forth', '1980-11-23', '2021-10-11', null, 'University of Kansas', 'DMD', 'Rick_Forth227@network.med', null, 6367049, 1, 776, 4527086, null, null)
	,('ACTIVE', 'Elise', 'Gates', '1991-07-28', '2021-09-06', null, 'Brandeis University', 'MD', 'Elise_Gates7550@network.med', null, 7706211, 1, 124, 7835764, null, null)
	,('ACTIVE', 'Ronald', 'Gavin', '1970-06-24', '2018-05-22', null, 'Georgetown University', 'DMD', 'Ronald_Gavin2505@network.med', 'Ronald_Gavin594@elnee.tech', 9321428, 1, 786, 6283038, 217, 6372105)
	,('ACTIVE', 'Nina', 'Glass', '1962-02-25', '2020-09-04', null, 'University of California, Santa Cruz', 'MS', 'Nina_Glass61@network.med', null, null, 0, 805, 7030856, null, null)
	,('ACTIVE', 'Chadwick', 'Grant', '1987-05-07', '2018-05-21', null, 'Oregon State University', 'MD', 'Chadwick_Grant9763@network.med', null, 5889728, 1, 172, 2768824, null, null)
	,('ACTIVE', 'Gil', 'Holmes', '1971-11-21', '2019-01-26', null, 'Tufts University', 'MD', 'Gil_Holmes4330@network.med', null, 4327019, 1, 487, 3755736, null, null)
	,('ACTIVE', 'Christy', 'James', '1999-05-28', '2022-04-28', null, 'Princeton University', 'DMD', 'Christy_James5412@network.med', null, 8840864, 1, 784, 4031778, null, null)
	,('ACTIVE', 'Hanna', 'John', '1994-07-22', '2019-03-18', null, 'University of Iowa', 'MS', 'Hanna_John7795@network.med', null, null, 0, 372, 4617862, null, null)
	,('PENDING', 'Eileen', 'Knight', '1979-05-30', null, null, 'Princeton University', 'DMD', 'Eileen_Knight9852@network.med', null, 9901931, 1, 735, 4266748, null, null)
	,('ACTIVE', 'Michael', 'Lewin', '1959-11-26', '2018-11-16', null, 'Wayne State University', 'MD', 'Michael_Lewin3410@network.med', null, 8770626, 1, 366, 8184067, null, null)
	,('ACTIVE', 'Sonya', 'Lloyd', '1966-12-18', '2018-07-09', null, 'Princeton University', 'DMD', 'Sonya_Lloyd1204@network.med', 'Sonya_Lloyd2153@gmail.com', 1687580, 1, 375, 4132831, 606, 7576206)
	,('ACTIVE', 'Michael', 'Matthews', '1974-08-10', '2019-03-11', null, 'Brown University', 'MD', 'Michael_Matthews2007@network.med', null, 4891665, 1, 144, 2447773, null, null)
	,('ACTIVE', 'Chad', 'Reading', '1971-08-28', '2021-08-13', null, 'Carnegie Mellon University', 'MD', 'Chad_Reading5431@network.med', 'Chad_Reading6207@infotech44.tech', 6001005, 1, 166, 4783280, 127, 3013328)
	,('PENDING', 'Barney', 'Rigg', '1993-04-04', null, null, 'Princeton University', 'DMD', 'Barney_Rigg3415@network.med', 'Barney_Rigg1519@tonsy.org', 4855616, 1, 624, 3742430, 830, 7501564)
	,('ACTIVE', 'Cherish', 'Rixon', '1991-09-25', '2022-09-08', null, 'University of Utah', 'DMD', 'Cherish_Rixon4183@network.med', null, 3067977, 1, 752, 3585712, null, null)
	,('ACTIVE', 'George', 'Selby', '1986-10-10', '2019-08-31', null, 'Vanderbilt University', 'DMD', 'George_Selby9054@network.med', null, 1230192, 1, 415, 3051828, null, null)
	,('ACTIVE', 'Harvey', 'Waterhouse', '1994-02-10', '2021-07-21', null, 'University of Colorado, Denver', 'DMD', 'Harvey_Waterhouse4763@network.med', null, 1998426, 1, 846, 5878527, null, null)
	,('INACTIVE', 'Maxwell', 'Waterhouse', '1970-10-19', '2018-06-12', '2021-02-04', 'Washington State University', 'DMD', 'Maxwell_Waterhouse9202@network.med', 'Maxwell_Waterhouse1382@womeona.net', 9589314, 1, 334, 2584515, 535, 6324016)
	,('ACTIVE', 'Gil', 'Wise', '1984-07-19', '2019-08-10', null, 'University of Southern California', 'MD', 'Gil_Wise4000@network.med', null, 7791225, 1, 025, 4528200, null, null);
go

/************
* LOAD DATA *
************/

declare @dt date = getdate();

insert into ref.PersonStatus (StatusCode,StatusDescription) values
	('ACTIVE','An active person in the network.')
	,('INACTIVE','A person no longer active in the network.')
	,('PENDING','A person who is being onboarded.');

insert into dbo.Person (NPI,IsProvider,PersonStatusId,FirstName,LastName,DateOfBirth,StartDate,TermDate)
