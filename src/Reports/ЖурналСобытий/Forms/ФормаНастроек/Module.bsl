#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ФормаПараметры = Новый Структура("КлючНазначенияИспользования, КлючПользовательскихНастроек,
									 |СформироватьПриОткрытии, ТолькоПросмотр,
									 |ФиксированныеНастройки, Раздел, Подсистема, ПодсистемаПредставление");
	ЗаполнитьЗначенияСвойств(ФормаПараметры, Параметры);
	ФормаПараметры.Вставить("Отбор", Новый Структура);
	Если ТипЗнч(Параметры.Отбор) = Тип("Структура") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ФормаПараметры.Отбор, Параметры.Отбор, Истина);
		Параметры.Отбор.Очистить();
	КонецЕсли;

	Если Параметры.Свойство("ВариантНаименование") И ЗначениеЗаполнено(Параметры.ВариантНаименование) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
			"ru = 'Изменение варианта отчета ""%1""'"), Параметры.ВариантНаименование);
	КонецЕсли;

	Если Параметры.Свойство("НастройкиОтчета", НастройкиОтчета) Тогда
		Если НастройкиОтчета.СхемаМодифицирована Тогда
			Отчет.КомпоновщикНастроек.Инициализировать(
				Новый ИсточникДоступныхНастроекКомпоновкиДанных(НастройкиОтчета.АдресСхемы));
		КонецЕсли;
	КонецЕсли;

	НастройкиКД = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Вариант");
	Если НастройкиКД = Неопределено Тогда
		НастройкиКД = Отчет.КомпоновщикНастроек.Настройки;
	КонецЕсли;

	Параметры.Свойство("ИдентификаторЭлементаСтруктурыНастроек", ИдентификаторЭлементаСтруктурыНастроек);

	Если Параметры.Свойство("ВариантМодифицирован") Тогда
		ВариантМодифицирован = Параметры.ВариантМодифицирован;
	КонецЕсли;

	Если Параметры.Свойство("ПользовательскиеНастройкиМодифицированы") Тогда
		ПользовательскиеНастройкиМодифицированы = Параметры.ПользовательскиеНастройкиМодифицированы;
	КонецЕсли;
	
	ИнициализироватьЭлементыВнешнегоНабораДанных();

КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойВариантаНаСервере(Настройки)

	Если ТипЗнч(ФормаПараметры.Отбор) = Тип("Структура") Тогда
		ОтчетыСервер.УстановитьФиксированныеОтборы(ФормаПараметры.Отбор, Настройки, НастройкиОтчета);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)

	НовыеНастройки = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	
	Отчет.КомпоновщикНастроек.ЗагрузитьФиксированныеНастройки(Новый НастройкиКомпоновкиДанных);
	ОтчетыКлиентСервер.ЗагрузитьНастройки(Отчет.КомпоновщикНастроек, НовыеНастройки);
	
	Для Каждого Раздел Из СтрРазделить("ЖурналРегистрации,ФоновыеЗадания", ",") Цикл
		
		ЭлементОтбора = НовыеНастройки.ПараметрыДанных.Элементы.Найти(Раздел + ".Параметры");
		Если Не (ЭлементОтбора.Использование И ТипЗнч(ЭлементОтбора.Значение) = Тип("ХранилищеЗначения")) Тогда 
			Продолжить;
		КонецЕсли;
		Для Каждого Элемент Из ЭлементОтбора.Значение.Получить() Цикл 
			
			Если Элемент.Ключ = "СтатусТранзакции" Или Элемент.Ключ = "Уровень" Или Элемент.Ключ = "Состояние" Тогда 
				Для Каждого Элемент1 Из ЭтаФорма[Раздел + "_" + Элемент.Ключ] Цикл 
					Элемент1.Пометка = Не Элемент.Значение.Найти(Элемент1.Значение) = Неопределено;
				КонецЦикла;
			Иначе 
				ЭтаФорма[Раздел + "_" + Элемент.Ключ] = Элемент.Значение;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаПоследниеПриИзменении(Элементы.ЖурналРегистрации_ЗаПоследние, Ложь);
	
	ЗаПоследниеПриИзменении(Элементы.ФоновыеЗадания_ЗаПоследние, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛокальныеПриИзменении(Элемент)
	
	Если Не ПустаяСтрока(ЭтаФорма[Элемент.Имя + "_Имя"]) Тогда
		Для Каждого Структура Из Отчет.КомпоновщикНастроек.Настройки.Структура Цикл
			ТипЭлемента = ТипЗнч(Структура);
			Если (ТипЭлемента = Тип("ГруппировкаКомпоновкиДанных") Или ТипЭлемента = Тип(
				"ГруппировкаТаблицыКомпоновкиДанных") Или ТипЭлемента = Тип("ГруппировкаДиаграммыКомпоновкиДанных"))
				И Структура.Имя = ЭтаФорма[Элемент.Имя + "_Имя"] Тогда
				Структура.Имя = "";
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Если ЭтаФорма[Элемент.Имя] Тогда

		Локальные2 = ?(СтрНачинаетсяС(Элемент.Имя, "ЖурналРегистрации_"), "ФоновыеЗадания", "ЖурналРегистрации")
			+ "_Локальные";
		ЭтаФорма[Локальные2] = Ложь;

		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(
			Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Если Не ПустаяСтрока(ЭлементСтруктуры.Имя) И ЭлементСтруктуры.Имя = ЭтаФорма[Локальные2 + "_Имя"] Тогда
			ЭтаФорма[Локальные2 + "_Имя"] = "";
		КонецЕсли;
		ЭлементСтруктуры.Имя = Лев(Элемент.Имя, СтрНайти(Элемент.Имя, "_")) + Новый УникальныйИдентификатор;
		ЭтаФорма[Элемент.Имя + "_Имя"] = ЭлементСтруктуры.Имя;

	Иначе

		ЭтаФорма[Элемент.Имя + "_Имя"] = "";

	КонецЕсли;

	Элементы.ЖурналРегистрации_ЛокальныеНайти.Доступность = Не (ЖурналРегистрации_Локальные Или ПустаяСтрока(
		ЖурналРегистрации_Локальные_Имя));
	Элементы.ФоновыеЗадания_ЛокальныеНайти.Доступность = Не (ФоновыеЗадания_Локальные Или ПустаяСтрока(
		ФоновыеЗадания_Локальные_Имя));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПараметрыВывода

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиПараметрыВыводаПриИзменении(Элемент)

	Строка = Элемент.ТекущиеДанные;
	ИдентификаторПараметра = "Заголовок";

	Если Строка <> Неопределено И Строка.Свойство("Параметр") И Строка.Параметр = ИдентификаторПараметра Тогда

		Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить(
			"ЗаголовокУстановленИнтерактивно", ЗначениеЗаполнено(Строка.Значение));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиПриАктивизацииПоля(Элемент)

	Перем ВыбраннаяСтраница;

	Если Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя = "КомпоновщикНастроекНастройкиНаличиеВыбора" Тогда

		ВыбраннаяСтраница = Элементы.СтраницаПолейВыбора;

	ИначеЕсли Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя = "КомпоновщикНастроекНастройкиНаличиеОтбора" Тогда

		ВыбраннаяСтраница = Элементы.СтраницаОтбора;

	ИначеЕсли Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя = "КомпоновщикНастроекНастройкиНаличиеПорядка" Тогда

		ВыбраннаяСтраница = Элементы.СтраницаПорядка;

	ИначеЕсли Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя
		= "КомпоновщикНастроекНастройкиНаличиеУсловногоОформления" Тогда

		ВыбраннаяСтраница = Элементы.СтраницаУсловногоОформления;

	ИначеЕсли Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя
		= "КомпоновщикНастроекНастройкиНаличиеПараметровВывода" Тогда

		ВыбраннаяСтраница = Элементы.СтраницаПараметровВывода;

	КонецЕсли;

	Если ВыбраннаяСтраница <> Неопределено Тогда

		Элементы.СтраницыНастроек.ТекущаяСтраница = ВыбраннаяСтраница;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СвойстваНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("Отчет.ЖурналСобытий.Форма.РедакторСоставаСвойства",
		Новый Структура("РедактируемыйСписок,ОтбираемыеПараметры,РежимВыбора", ЭтаФорма[Элемент.Имя], Элемент.Имя,
		СтрЧислоВхождений(Элемент.Имя, "_РегламентноеЗадание_")), ЭтаФорма, , , ,
		Новый ОписаниеОповещения("ЗавершитьРедактированиеСоставаСвойств", ЭтотОбъект, Элемент.Имя), );
	             
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиПриАктивизацииСтроки(Элемент)

	ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(
		Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
	ТипЭлемента = ТипЗнч(ЭлементСтруктуры);

	ЭтоКорень = Ложь;
	ЭтоГруппа = Ложь;
	Если ТипЭлемента = Неопределено Или ТипЭлемента = Тип("КоллекцияЭлементовСтруктурыДиаграммыКомпоновкиДанных")
		Или ТипЭлемента = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Тогда

		ПоляГруппировкиНедоступны();
		ВыбранныеПоляНедоступны();
		ОтборНедоступен();
		ПорядокНедоступен();
		УсловноеОформлениеНедоступно();
		ПараметрыВыводаНедоступны();
		
	ИначеЕсли ТипЭлемента = Тип("НастройкиКомпоновкиДанных") Или ТипЭлемента = Тип(
		"НастройкиВложенногоОбъектаКомпоновкиДанных") Тогда

		ПоляГруппировкиНедоступны();

		ЛокальныеВыбранныеПоля = Истина;
		Элементы.ЛокальныеВыбранныеПоля.ТолькоПросмотр = Истина;
		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.НастройкиВыбранныхПолей;

		ЛокальныйОтбор = Истина;
		Элементы.ЛокальныйОтбор.ТолькоПросмотр = Истина;
		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.НастройкиОтбора;

		ЛокальныйПорядок = Истина;
		Элементы.ЛокальныйПорядок.ТолькоПросмотр = Истина;
		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.НастройкиПорядка;

		ЛокальноеУсловноеОформление = Истина;
		Элементы.ЛокальноеУсловноеОформление.ТолькоПросмотр = Истина;
		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.НастройкиУсловногоОформления;

		ЛокальныеПараметрыВывода = Истина;
		Элементы.ЛокальныеПараметрыВывода.ТолькоПросмотр = Истина;
		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.НастройкиПараметровВывода;
		
		ЭтоКорень = Истина;
		
	ИначеЕсли ТипЭлемента = Тип("ГруппировкаКомпоновкиДанных") Или ТипЭлемента = Тип(
		"ГруппировкаТаблицыКомпоновкиДанных") Или ТипЭлемента = Тип("ГруппировкаДиаграммыКомпоновкиДанных") Тогда

		Элементы.СтраницыПолейГруппировки.ТекущаяСтраница = Элементы.НастройкиПолейГруппировки;

		ВыбранныеПоляДоступны(ЭлементСтруктуры);
		ОтборДоступен(ЭлементСтруктуры);
		ПорядокДоступен(ЭлементСтруктуры);
		УсловноеОформлениеДоступно(ЭлементСтруктуры);
		ПараметрыВыводаДоступны(ЭлементСтруктуры);
		
		ЭтоГруппа = Истина;
		
	ИначеЕсли ТипЭлемента = Тип("ТаблицаКомпоновкиДанных") Или ТипЭлемента = Тип("ДиаграммаКомпоновкиДанных") Тогда

		ПоляГруппировкиНедоступны();
		ВыбранныеПоляДоступны(ЭлементСтруктуры);
		ОтборНедоступен();
		ПорядокНедоступен();
		УсловноеОформлениеДоступно(ЭлементСтруктуры);
		ПараметрыВыводаДоступны(ЭлементСтруктуры);
		
	КонецЕсли;
	
	Для Каждого Раздел Из СтрРазделить("ЖурналРегистрации,ФоновыеЗадания", ",") Цикл
		
		Элементы[Раздел + "_Локальные"].Доступность = ЭтоГруппа; 
		ЭтаФорма[Раздел + "_Локальные"] = ЭтоГруппа И Не ПустаяСтрока(ЭлементСтруктуры.Имя) И ЭлементСтруктуры.Имя
			= ЭтаФорма[Раздел + "_Локальные_Имя"];
			
		Для Каждого Элемент Из Элементы["Страница" + Раздел].ПодчиненныеЭлементы Цикл
			Если Не Элемент.Имя = Раздел + "_ГруппаЛокальные" Тогда
				Элемент.Доступность = ЭтоКорень Или ЭтаФорма[Раздел + "_Локальные"];
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Элементы.ЖурналРегистрации_ЛокальныеНайти.Доступность = Не (ЖурналРегистрации_Локальные Или ПустаяСтрока(
		ЖурналРегистрации_Локальные_Имя));
	Элементы.ФоновыеЗадания_ЛокальныеНайти.Доступность = Не (ФоновыеЗадания_Локальные Или ПустаяСтрока(
		ФоновыеЗадания_Локальные_Имя));

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКОтчету(Элемент)

	ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(
		Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
	НастройкиЭлемента =  Отчет.КомпоновщикНастроек.Настройки.НастройкиЭлемента(ЭлементСтруктуры);
	Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока = Отчет.КомпоновщикНастроек.Настройки.ПолучитьИдентификаторПоОбъекту(
		НастройкиЭлемента);

КонецПроцедуры

&НаКлиенте
Процедура ЛокальныеВыбранныеПоляПриИзменении(Элемент)

	Если ЛокальныеВыбранныеПоля Тогда

		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.НастройкиВыбранныхПолей;

	Иначе

		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.ОтключенныеНастройкиВыбранныхПолей;

		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(
			Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьВыборЭлемента(ЭлементСтруктуры);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЛокальныйОтборПриИзменении(Элемент)

	Если ЛокальныйОтбор Тогда

		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.НастройкиОтбора;

	Иначе

		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.ОтключенныеНастройкиОтбора;

		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(
			Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьОтборЭлемента(ЭлементСтруктуры);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЛокальныйПорядокПриИзменении(Элемент)

	Если ЛокальныйПорядок Тогда

		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.НастройкиПорядка;

	Иначе

		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.ОтключенныеНастройкиПорядка;

		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(
			Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьПорядокЭлемента(ЭлементСтруктуры);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЛокальноеУсловноеОформлениеПриИзменении(Элемент)

	Если ЛокальноеУсловноеОформление Тогда

		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.НастройкиУсловногоОформления;

	Иначе

		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.ОтключенныеНастройкиУсловногоОформления;

		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(
			Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьУсловноеОформлениеЭлемента(ЭлементСтруктуры);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЛокальныеПараметрыВыводаПриИзменении(Элемент)

	Если ЛокальныеПараметрыВывода Тогда

		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.НастройкиПараметровВывода;

	Иначе

		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.ОтключенныеНастройкиПараметровВывода;

		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(
			Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьПараметрыВыводаЭлемента(ЭлементСтруктуры);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаПоследниеПриИзменении(Элемент, Интерактивно = Истина)
	
	Ключ = Лев(Элемент.Имя, СтрНайти(Элемент.Имя, "_"));
	Элементы[Ключ + "ГруппаСтандартныйПериод"].Доступность = Не ЭтаФорма[Ключ + "ЗаПоследние"];
	
	Если Интерактивно Тогда
		ЭлементВнешнегоНабораДанныхПриИзменении();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЭлементВнешнегоНабораДанныхПриИзменении(Элемент = Неопределено)
	
	ВариантМодифицирован = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)

	СохранитьЭлементыВнешнегоНабораДанных();
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("Переформировать", Ложь);
	РезультатВыбора.Вставить("КомпоновщикНастроекКД", Отчет.КомпоновщикНастроек);
	РезультатВыбора.Вставить("ВариантМодифицирован", ВариантМодифицирован);
	РезультатВыбора.Вставить("ПользовательскиеНастройкиМодифицированы", ВариантМодифицирован
		Или ПользовательскиеНастройкиМодифицированы);

#Если ВебКлиент Тогда
	РезультатВыбора.ВариантМодифицирован = Истина; // Для платформы.
	РезультатВыбора.ПользовательскиеНастройкиМодифицированы = Истина;
#КонецЕсли

	Если РезультатВыбора.ПользовательскиеНастройкиМодифицированы Тогда
		РезультатВыбора.Вставить("СброситьПользовательскиеНастройки", Истина);
	КонецЕсли;

	ОповеститьОВыборе(РезультатВыбора);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФлажки(Команда)
	
	Пометка = СтрЗаканчиваетсяНа(Команда.Имя, "УстановитьФлажки");
	Для Каждого Элемент Из ЭтаФорма[СтрЗаменить(Команда.Имя, ?(Пометка, "УстановитьФлажки", "СнятьФлажки"), "")] Цикл
		Элемент.Пометка = Пометка;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	Путь = СтрЗаменить(Команда.Имя, "ВыбратьПериод", "Период");
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода;
	Диалог.Период = ЭтаФорма[Путь];
	Диалог.Показать(Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект, Путь));
	
КонецПроцедуры

&НаКлиенте
Процедура ЛокальныеНайти(Команда)

	Ключ = ЭтаФорма[СтрЗаменить(Команда.Имя, "Найти", "_Имя")];
	Для Каждого Структура Из Отчет.КомпоновщикНастроек.Настройки.Структура Цикл
		ТипЭлемента = ТипЗнч(Структура);
		Если (ТипЭлемента = Тип("ГруппировкаКомпоновкиДанных") Или ТипЭлемента = Тип(
				"ГруппировкаТаблицыКомпоновкиДанных") Или ТипЭлемента = Тип("ГруппировкаДиаграммыКомпоновкиДанных"))
			И Структура.Имя = Ключ Тогда
			Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока = Отчет.КомпоновщикНастроек.Настройки.ПолучитьИдентификаторПоОбъекту(
				Структура);
			Прервать;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПоляГруппировкиНедоступны()

	Элементы.СтраницыПолейГруппировки.ТекущаяСтраница = Элементы.НедоступныеНастройкиПолейГруппировки;

КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПоляДоступны(ЭлементСтруктуры)

	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеВыбораУЭлемента(ЭлементСтруктуры) Тогда

		ЛокальныеВыбранныеПоля = Истина;
		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.НастройкиВыбранныхПолей;

	Иначе

		ЛокальныеВыбранныеПоля = Ложь;
		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.ОтключенныеНастройкиВыбранныхПолей;

	КонецЕсли;

	Элементы.ЛокальныеВыбранныеПоля.ТолькоПросмотр = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПоляНедоступны()

	ЛокальныеВыбранныеПоля = Ложь;
	Элементы.ЛокальныеВыбранныеПоля.ТолькоПросмотр = Истина;
	Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.НедоступныеНастройкиВыбранныхПолей;

КонецПроцедуры

&НаКлиенте
Процедура ОтборДоступен(ЭлементСтруктуры)

	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеОтбораУЭлемента(ЭлементСтруктуры) Тогда

		ЛокальныйОтбор = Истина;
		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.НастройкиОтбора;

	Иначе

		ЛокальныйОтбор = Ложь;
		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.ОтключенныеНастройкиОтбора;

	КонецЕсли;

	Элементы.ЛокальныйОтбор.ТолькоПросмотр = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ОтборНедоступен()

	ЛокальныйОтбор = Ложь;
	Элементы.ЛокальныйОтбор.ТолькоПросмотр = Истина;
	Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.НедоступныеНастройкиОтбора;

КонецПроцедуры

&НаКлиенте
Процедура ПорядокДоступен(ЭлементСтруктуры)

	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеПорядкаУЭлемента(ЭлементСтруктуры) Тогда

		ЛокальныйПорядок = Истина;
		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.НастройкиПорядка;

	Иначе

		ЛокальныйПорядок = Ложь;
		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.ОтключенныеНастройкиПорядка;

	КонецЕсли;

	Элементы.ЛокальныйПорядок.ТолькоПросмотр = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ПорядокНедоступен()

	ЛокальныйПорядок = Ложь;
	Элементы.ЛокальныйПорядок.ТолькоПросмотр = Истина;
	Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.НедоступныеНастройкиПорядка;

КонецПроцедуры

&НаКлиенте
Процедура УсловноеОформлениеДоступно(ЭлементСтруктуры)

	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеУсловногоОформленияУЭлемента(ЭлементСтруктуры) Тогда

		ЛокальноеУсловноеОформление = Истина;
		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.НастройкиУсловногоОформления;

	Иначе

		ЛокальноеУсловноеОформление = Ложь;
		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.ОтключенныеНастройкиУсловногоОформления;

	КонецЕсли;

	Элементы.ЛокальноеУсловноеОформление.ТолькоПросмотр = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура УсловноеОформлениеНедоступно()

	ЛокальноеУсловноеОформление = Ложь;
	Элементы.ЛокальноеУсловноеОформление.ТолькоПросмотр = Истина;
	Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.НедоступныеНастройкиУсловногоОформления;

КонецПроцедуры

&НаКлиенте
Процедура ПараметрыВыводаДоступны(ЭлементСтруктуры)

	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеПараметровВыводаУЭлемента(ЭлементСтруктуры) Тогда

		ЛокальныеПараметрыВывода = Истина;
		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.НастройкиПараметровВывода;

	Иначе

		ЛокальныеПараметрыВывода = Ложь;
		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.ОтключенныеНастройкиПараметровВывода;

	КонецЕсли;

	Элементы.ЛокальныеПараметрыВывода.ТолькоПросмотр = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ПараметрыВыводаНедоступны()

	ЛокальныеПараметрыВывода = Ложь;
	Элементы.ЛокальныеПараметрыВывода.ТолькоПросмотр = Истина;
	Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.НедоступныеНастройкиПараметровВывода;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(Период, ДополнительныеПараметры) Экспорт 
	
	Если Период = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЭтаФорма[ДополнительныеПараметры] = Период;
	
	ЭлементВнешнегоНабораДанныхПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактированиеСоставаСвойств(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Или РезультатЗакрытия = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;

	Если СтрЧислоВхождений(ДополнительныеПараметры, "_РегламентноеЗадание_Наименование") Тогда
		ЭтаФорма[ДополнительныеПараметры] = РезультатЗакрытия.Представление;
		ЭтаФорма[СтрЗаменить(ДополнительныеПараметры, "_Наименование",
			"_УникальныйИдентификатор")] = Новый УникальныйИдентификатор(РезультатЗакрытия.Значение);
	Иначе
		ЭтаФорма[ДополнительныеПараметры] = РезультатЗакрытия;
	КонецЕсли;
	
	ЭлементВнешнегоНабораДанныхПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ФоновыеЗадания_РегламентноеЗадание_НаименованиеОчистка(Элемент, СтандартнаяОбработка)
	
	ФоновыеЗадания_РегламентноеЗадание_УникальныйИдентификатор = Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьЭлементыВнешнегоНабораДанных()
	
	ЭлементОтбора = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ЖурналРегистрации.Параметры");
	ЭлементОтбора.Использование = Ложь;
	ЭлементОтбора.Значение = Неопределено;
	
	Отбор = Новый Структура("Локальные_Имя", ЖурналРегистрации_Локальные_Имя);
	
	ПоляТипаСписок = "Пользователь,ВспомогательныйIPПорт,ИмяПриложения,Компьютер,Метаданные,ОсновнойIPПорт,РабочийСервер,Сеанс,Событие";
	Для Каждого Элемент Из СтрРазделить(ПоляТипаСписок, ",") Цикл 
		Если ЭтаФорма["ЖурналРегистрации_" + Элемент].Количество() Тогда 
			Отбор.Вставить(Элемент, ЭтаФорма["ЖурналРегистрации_" + Элемент]);
		КонецЕсли;
	КонецЦикла;
	Если ЖурналРегистрации_МаксимальноеКоличество Тогда
		Отбор.Вставить("МаксимальноеКоличество", ЖурналРегистрации_МаксимальноеКоличество);
	КонецЕсли;
	Если Не (ЖурналРегистрации_Данные = Неопределено Или ЖурналРегистрации_Данные.Пустая()) Тогда 
		Отбор.Вставить("Данные", ЖурналРегистрации_Данные);
	КонецЕсли;
	Если ЖурналРегистрации_ЗаПоследние Тогда 
		Отбор.Вставить("ЗаПоследние", ЖурналРегистрации_ЗаПоследние);
	ИначеЕсли ЗначениеЗаполнено(ЖурналРегистрации_Период.ДатаНачала) Тогда 
		Отбор.Вставить("Период", ЖурналРегистрации_Период);
	КонецЕсли;
	Если Не ПустаяСтрока(ЖурналРегистрации_ПредставлениеДанных) Тогда 
		Отбор.Вставить("ПредставлениеДанных", ЖурналРегистрации_ПредставлениеДанных);
	КонецЕсли;
	Если Не ПустаяСтрока(ЖурналРегистрации_Транзакция) Тогда 
		Отбор.Вставить("Транзакция", ЖурналРегистрации_Транзакция);
	КонецЕсли;
	СтатусТранзакции = Новый Массив;
	Для Каждого Элемент Из ЖурналРегистрации_СтатусТранзакции Цикл 
		Если Элемент.Пометка Тогда 
			СтатусТранзакции.Добавить(Элемент.Значение);
		КонецЕсли;
	КонецЦикла;
	Если СтатусТранзакции.Количество() И СтатусТранзакции.Количество() < 4 Тогда 
		Отбор.Вставить("СтатусТранзакции", СтатусТранзакции);
	КонецЕсли;
	Уровень = Новый Массив;
	Для Каждого Элемент Из ЖурналРегистрации_Уровень Цикл 
		Если Элемент.Пометка Тогда 
			Уровень.Добавить(Элемент.Значение);
		КонецЕсли;
	КонецЦикла;
	Если Уровень.Количество() И Уровень.Количество() < 4 Тогда 
		Отбор.Вставить("Уровень", Уровень);
	КонецЕсли;
	
	Если Отбор.Количество() Тогда
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.Значение = Новый ХранилищеЗначения(Отбор);
	КонецЕсли;
	
	ЭлементОтбора = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ФоновыеЗадания.Параметры");
	ЭлементОтбора.Использование = Ложь;
	ЭлементОтбора.Значение = Неопределено;
	
	Отбор = Новый Структура("Локальные_Имя", ФоновыеЗадания_Локальные_Имя);
	
	ПоляТипаСтрока = "ИмяМетода,Ключ,Наименование,УникальныйИдентификатор";
	Для Каждого Элемент Из СтрРазделить(ПоляТипаСтрока, ",") Цикл 
		Если Не ПустаяСтрока(ЭтаФорма["ФоновыеЗадания_" + Элемент]) Тогда 
			Отбор.Вставить(Элемент, ЭтаФорма["ФоновыеЗадания_" + Элемент]);
		КонецЕсли;
	КонецЦикла;
	Если ФоновыеЗадания_ЗаПоследние Тогда 
		Отбор.Вставить("ЗаПоследние", ФоновыеЗадания_ЗаПоследние);
	ИначеЕсли ЗначениеЗаполнено(ФоновыеЗадания_Период.ДатаНачала) Тогда 
		Отбор.Вставить("Период", ФоновыеЗадания_Период);
	КонецЕсли;
	Если ЗначениеЗаполнено(ФоновыеЗадания_РегламентноеЗадание_УникальныйИдентификатор) Тогда 
		Отбор.Вставить("РегламентноеЗадание_Наименование", ФоновыеЗадания_РегламентноеЗадание_Наименование);
		Отбор.Вставить("РегламентноеЗадание_УникальныйИдентификатор", ФоновыеЗадания_РегламентноеЗадание_УникальныйИдентификатор);
	КонецЕсли;
	Состояние = Новый Массив;
	Для Каждого Элемент Из ФоновыеЗадания_Состояние Цикл 
		Если Элемент.Пометка Тогда 
			Состояние.Добавить(Элемент.Значение);
		КонецЕсли;
	КонецЦикла;
	Если Состояние.Количество() И Состояние.Количество() < 4 Тогда 
		Отбор.Вставить("Состояние", Состояние);
	КонецЕсли;
	
	Если Отбор.Количество() Тогда
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.Значение = Новый ХранилищеЗначения(Отбор);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьЭлементыВнешнегоНабораДанных()

	ЖурналРегистрации_Уровень.Добавить("Ошибка",, Истина);
	ЖурналРегистрации_Уровень.Добавить("Предупреждение",, Истина);
	ЖурналРегистрации_Уровень.Добавить("Информация",, Истина);
	ЖурналРегистрации_Уровень.Добавить("Примечание",, Истина);
	
	ЖурналРегистрации_СтатусТранзакции.Добавить("НетТранзакции",, Истина);
	ЖурналРегистрации_СтатусТранзакции.Добавить("Зафиксирована",, Истина);
	ЖурналРегистрации_СтатусТранзакции.Добавить("НеЗавершена",, Истина);
	ЖурналРегистрации_СтатусТранзакции.Добавить("Отменена",, Истина);
	
	ФоновыеЗадания_Состояние.Добавить("Активно",, Истина);
	ФоновыеЗадания_Состояние.Добавить("Завершено",, Истина);
	ФоновыеЗадания_Состояние.Добавить("ЗавершеноАварийно", "Завершено аварийно", Истина);
	ФоновыеЗадания_Состояние.Добавить("Отменено",, Истина);

КонецПроцедуры

#КонецОбласти