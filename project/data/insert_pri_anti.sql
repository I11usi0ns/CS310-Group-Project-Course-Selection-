use SELECTION;

insert into Anti_requisite(id_1,id_2)
values("MATH 101","MATH 105");

insert into Anti_requisite(id_1,id_2)
values("MATH 105","MATH 101");

insert into Anti_requisite(id_1,id_2)
values("MATH 302","MATH 304");

insert into Anti_requisite(id_1,id_2)
values("MATH 304","MATH 302");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 105","MATH 201","1");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 101","MATH 202","2");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 105","MATH 202","2");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 105","MATH 203","3");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 101","MATH 203","3");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 101","MATH 206","5");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 105","MATH 206","5");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","MATH 302","9");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 302","10");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 101","MATH 302","11");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","MATH 302","11");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","MATH 303","12");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 303","13");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","MATH 304","14");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 304","15");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 206","MATH 304","16");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 101","MATH 304","17");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","MATH 304","17");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","MATH 305","18");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 305","19");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 101","MATH 305","20");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","MATH 305","20");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","MATH 307","23");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 307","24");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 203","MATH 308","25");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 401","29");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 303","MATH 403","30");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 308","MATH 403","31");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","MATH 405","33");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 405","34");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 206","MATH 405","35");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 303","MATH 406","36");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","MATH 407","37");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 407","38");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","MATH 408","39");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 408","40");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 308","MATH 409","41");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 101","MATH 411","42");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 105","MATH 411","42");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 206","MATH 411","43");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 412","44");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 308","MATH 412","45");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 308","MATH 450","51");

insert into Anti_requisite(id_1,id_2)
values("COMPSCI 201","COMPSCI 101");

insert into Anti_requisite(id_1,id_2)
values("COMPSCI 308","COMPSCI 301");

insert into Anti_requisite(id_1,id_2)
values("COMPSCI 310","COMPSCI 301");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 203","53");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","COMPSCI 203","53");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 205","55");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 301","60");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 309","COMPSCI 304","67");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 306","68");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 205","COMPSCI 306","69");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 308","71");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 203","COMPSCI 308","72");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 206","COMPSCI 308","73");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","COMPSCI 309","74");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","COMPSCI 309","75");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 206","COMPSCI 309","76");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 309","77");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 310","78");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 301","COMPSCI 401","81");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 306","COMPSCI 401","81");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 308","COMPSCI 401","81");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 309","COMPSCI 402","82");


