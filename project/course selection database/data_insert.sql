use SELECTION;

insert into Anti_requisite(id_1,id_2)
values("MATH 101","MATH 105");

insert into Anti_requisite(id_1,id_2)
values("MATH 105","MATH 101");

insert into Anti_requisite(id_1,id_2)
values("MATH 205","MATH 206");

insert into Anti_requisite(id_1,id_2)
values("MATH 206","MATH 205");

insert into Anti_requisite(id_1,id_2)
values("MATH 302","MATH 304");

insert into Anti_requisite(id_1,id_2)
values("MATH 304","MATH 302");

insert into Anti_requisite(id_1,id_2)
values("MATH 309","MATH 405");

insert into Anti_requisite(id_1,id_2)
values("MATH 405","MATH 309");

insert into Anti_requisite(id_1,id_2)
values("MATH 206","MATH 205");

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
values("MATH 101","MATH 205","4");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 105","MATH 205","4");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 101","MATH 206","5");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 105","MATH 206","5");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 205","MATH 301","6");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 206","MATH 301","6");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 301","7");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","MATH 301","8");

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
values("MATH 205","MATH 304","16");

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
values("COMPSCI 203","MATH 306","21");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 206","MATH 306","22");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","MATH 307","23");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 307","24");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 203","MATH 308","25");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 205","MATH 308","26");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","MATH 317","27");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 317","28");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 401","29");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 303","MATH 403","30");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 308","MATH 403","31");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 205","MATH 404","32");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 206","MATH 404","32");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","MATH 405","33");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 405","34");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 205","MATH 405","35");

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
values("MATH 205","MATH 411","43");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 206","MATH 411","43");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 412","44");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 308","MATH 412","45");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 302","MATH 413","46");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 303","MATH 413","47");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 403","MATH 413","48");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","MATH 414","49");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","MATH 414","50");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 308","MATH 450","51");

insert into Anti_requisite(id_1,id_2)
values("COMPSCI 201","COMPSCI 101");

insert into Anti_requisite(id_1,id_2)
values("COMPSCI 101","COMPSCI 201");

insert into Anti_requisite(id_1,id_2)
values("COMPSCI 308","COMPSCI 301");

insert into Anti_requisite(id_1,id_2)
values("COMPSCI 310","COMPSCI 301");

insert into Anti_requisite(id_1,id_2)
values("COMPSCI 405","COMPSCI 309");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 101","COMPSCI 201","52");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 203","53");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","COMPSCI 203","53");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 204","54");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 205","55");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 101","COMPSCI 206","56");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 105","COMPSCI 206","56");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 205","COMPSCI 206","57");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 101","COMPSCI 206","58");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 206","58");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 101","COMPSCI 210","59");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 210","59");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 205","COMPSCI 210","59");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 206","COMPSCI 210","59");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 301","60");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 309","COMPSCI 302","61");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 405_COMPSCI 201","COMPSCI 302","61");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 405","MATH 405_COMPSCI 201","62");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","MATH 405_COMPSCI 201","63");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","COMPSCI 303","64");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 303","65");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 205","COMPSCI 303","66");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 206","COMPSCI 303","66");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 309","COMPSCI 304","67");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 405_COMPSCI 201","COMPSCI 304","67");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 306","68");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 205","COMPSCI 306","69");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 307","70");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 308","71");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 203","COMPSCI 308","72");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 205","COMPSCI 308","73");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 206","COMPSCI 308","73");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 201","COMPSCI 309","74");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 202","COMPSCI 309","75");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 205","COMPSCI 309","76");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 206","COMPSCI 309","76");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 309","77");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 310","78");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 205","COMPSCI 311","79");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 312","80");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 101","COMPSCI 312","80");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 301","COMPSCI 401","81");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 306","COMPSCI 401","81");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 308","COMPSCI 401","81");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 311","COMPSCI 401","81");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 309","COMPSCI 402","82");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 405_COMPSCI 201","COMPSCI 402","82");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 205","COMPSCI 403","83");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 205","COMPSCI 404","84");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 205","COMPSCI 405","85");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 306","COMPSCI 405","86");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 201","COMPSCI 406","87");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 203","COMPSCI 406","88");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 302","COMPSCI 413","89");

insert into pre_requisite(id_first,id_second,id_or)
values("COMPSCI 303","COMPSCI 413","90");

insert into pre_requisite(id_first,id_second,id_or)
values("MATH 403","COMPSCI 413","91");