#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем Уровень, СтатусТранзакции, Состояние;

#КонецОбласти
	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// Возвращает сведения о внешнем отчете.
//
// Возвращаемое значение:
//   см. ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке.
//
Функция СведенияОВнешнейОбработке() Экспорт
    
    ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("");
    
    ПараметрыРегистрации.Вставить("Вид", ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительныйОтчет());
    ПараметрыРегистрации.Вставить("Версия", "1.0");
    //ПараметрыРегистрации.Вставить("Наименование", "");
    //ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь); // По умолчанию Истина.
    //ПараметрыРегистрации.Вставить("Информация", "");
    //ПараметрыРегистрации.Вставить("ОпределитьНастройкиФормы", Истина) По умолчанию Ложь. Переопределяет настройки общей формы отчета и подписываться на ее события.
    
    //Разрешения
    //ПараметрыРегистрации.Разрешения.Добавить(РаботаВБезопасномРежиме.Разрешение);
    
    //Назначение
    //ПараметрыРегистрации.Назначение.Добавить("Справочник.ДополнительныеОтчетыИОбработки");
    //ПараметрыРегистрации.Назначение.Добавить("Справочник.Пользователи");
    
    НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
    НоваяКоманда.Представление		  = "Журнал событий";
    НоваяКоманда.Идентификатор		  = "ЖурналСобытий"; // строкой, через запятую.
    НоваяКоманда.Использование		  = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
    НоваяКоманда.ПоказыватьОповещение = Истина; // При запуске выводится оповещение "Команда выполняется...", кроме Использование = "ОткрытиеФормы".
    НоваяКоманда.Модификатор		  = "ПечатьMXL"; // когда Вид = "ПечатнаяФорма": "ПечатьMXL"; когда Вид = "ПечатнаяФорма" и Использование = "ЗагрузкаДанныхИзФайла": полное имя объекта метаданных (справочника).
    НоваяКоманда.Скрыть				  = Ложь; // Истина - служебная команда, скрывается в карточке дополнительного объекта.  
    НоваяКоманда.ЗаменяемыеКоманды	  = ""; // Идентификаторы стандартных команд (строкой, через запятую), которые заменяются обработкой.
    
    Возврат ПараметрыРегистрации;
    
КонецФункции

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения, Неопределено - форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.Вставить("РазрешеноВыбиратьИНастраиватьВариантыБезСохранения", Ложь);
	Настройки.Вставить("РазрешеноЗагружатьСхему", Истина);
	Настройки.Вставить("РазрешеноРедактироватьСхему", Истина);
	Настройки.Вставить("РазрешеноВосстанавливатьСтандартнуюСхему", Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДокументРезультат.Очистить();
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ЖурналРегистрации", ЖурналРегистрации(Настройки));
	ВнешниеНаборыДанных.Вставить("ФоновыеЗадания", ФоновыеЗадания(Настройки));
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки, , Тип(
		"ГенераторМакетаКомпоновкиДанных"));
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
	
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой",
		ОтчетыСервер.ОтчетПустой(ЭтотОбъект, ПроцессорКомпоновкиДанных));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЖурналРегистрации(Настройки)

 	Таблица = ПустаяТаблицаНабораДанных("ЖурналРегистрации");
 	
 	Отбор = ПреобразованиеОтбора(Настройки, "ЖурналРегистрации");
 	Если Отбор = Неопределено Тогда
 		Возврат Таблица;
 	КонецЕсли;
 	
 	Если Отбор.Свойство("МаксимальноеКоличество") Тогда
 		МаксимальноеКоличество = Отбор["МаксимальноеКоличество"]; 
 		Отбор.Удалить("МаксимальноеКоличество");
 	Иначе
 		МаксимальноеКоличество = 0;
 	КонецЕсли;
 	 	 	
	ВыгрузитьЖурналРегистрации(Таблица, Отбор,,, МаксимальноеКоличество);	
	Для Каждого Элемент Из Таблица Цикл
		Элемент.Уровень = Уровень.Получить(Элемент.Уровень);
		Элемент.СтатусТранзакции = СтатусТранзакции.Получить(Элемент.СтатусТранзакции);
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

Функция ФоновыеЗадания(Настройки)
	
	Таблица = ПустаяТаблицаНабораДанных("ФоновыеЗадания");
	
	Отбор = ПреобразованиеОтбора(Настройки, "ФоновыеЗадания");
 	Если Отбор = Неопределено Тогда
 		Возврат Таблица;
 	КонецЕсли;
	
	Для Каждого Элемент Из ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор) Цикл

		НоваяСтрока = Таблица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Элемент);
		Если Не Элемент.ИнформацияОбОшибке = Неопределено Тогда
			НоваяСтрока.ИнформацияОбОшибке_ИмяМодуля = Элемент.ИнформацияОбОшибке.ИмяМодуля;
			НоваяСтрока.ИнформацияОбОшибке_ИсходнаяСтрока = Элемент.ИнформацияОбОшибке.ИсходнаяСтрока;
			НоваяСтрока.ИнформацияОбОшибке_НомерСтроки = Элемент.ИнформацияОбОшибке.НомерСтроки;
			НоваяСтрока.ИнформацияОбОшибке_Описание = Элемент.ИнформацияОбОшибке.Описание;
			НоваяСтрока.ИнформацияОбОшибке_Причина = ?(Элемент.ИнформацияОбОшибке.Причина = Неопределено, "",
				ПодробноеПредставлениеОшибки(Элемент.ИнформацияОбОшибке.Причина));
		КонецЕсли;
		Если Не Элемент.РегламентноеЗадание = Неопределено Тогда
			НоваяСтрока.РегламентноеЗадание_ИмяПользователя = Элемент.РегламентноеЗадание.ИмяПользователя;
			НоваяСтрока.РегламентноеЗадание_ИнтервалПовтораПриАварийномЗавершении = Элемент.РегламентноеЗадание.ИнтервалПовтораПриАварийномЗавершении;
			НоваяСтрока.РегламентноеЗадание_Использование = Элемент.РегламентноеЗадание.Использование;
			НоваяСтрока.РегламентноеЗадание_Ключ = Элемент.РегламентноеЗадание.Ключ;
			НоваяСтрока.РегламентноеЗадание_КоличествоПовторовПриАварийномЗавершении = Элемент.РегламентноеЗадание.КоличествоПовторовПриАварийномЗавершении;
			НоваяСтрока.РегламентноеЗадание_Метаданные = Элемент.РегламентноеЗадание.Метаданные.ПолноеИмя();
			НоваяСтрока.РегламентноеЗадание_Наименование = Элемент.РегламентноеЗадание.Наименование;
			НоваяСтрока.РегламентноеЗадание_Предопределенное = Элемент.РегламентноеЗадание.Предопределенное;
			НоваяСтрока.РегламентноеЗадание_УникальныйИдентификатор = Элемент.РегламентноеЗадание.УникальныйИдентификатор;
		КонецЕсли;
		НоваяСтрока.Состояние = Состояние.Получить(Элемент.Состояние);

	КонецЦикла;

	Возврат Таблица;
	
КонецФункции

Функция ПустаяТаблицаНабораДанных(ИмяНабора)
	
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Найти(ИмяНабора);
	Если Не ТипЗнч(НаборДанных) = Тип("НаборДанныхОбъектСхемыКомпоновкиДанных") Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	Таблица = Новый ТаблицаЗначений;
	Для Каждого Элемент Из НаборДанных.Поля Цикл 
		Если ТипЗнч(Элемент) = Тип("ПолеНабораДанныхСхемыКомпоновкиДанных") Тогда 
			Таблица.Колонки.Добавить(Элемент.Поле, Элемент.ТипЗначения);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

Функция ПреобразованиеОтбора(Настройки, Раздел)
	
	Параметры = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Настройки.ДополнительныеСвойства, Раздел + "_Параметры");
	Если Параметры = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	Отбор = Новый Структура;
	Локальные_Имя = "";
	Для Каждого Элемент Из Параметры Цикл

		Если Элемент.Ключ = "Локальные_Имя" Тогда
			Локальные_Имя = Элемент.Значение;

		ИначеЕсли Элемент.Ключ = "ЗаПоследние" Тогда

			Если Раздел = "ЖурналРегистрации" Тогда
				Отбор.Вставить("ДатаНачала", ТекущаяДата() - Элемент.Значение * 60);
				Отбор.Вставить("ДатаОкончания", ТекущаяДата() + 1800);

			ИначеЕсли Раздел = "ФоновыеЗадания" Тогда
				Отбор.Вставить("Начало", ТекущаяДата() - Элемент.Значение * 60);
				Отбор.Вставить("Конец", ТекущаяДата() + 1800);

			КонецЕсли;

		ИначеЕсли Элемент.Ключ = "Период" Тогда

			Если Параметры.Свойство("ЗаПоследние") Тогда
				Продолжить;

			ИначеЕсли Раздел = "ЖурналРегистрации" Тогда
				Отбор.Вставить("ДатаНачала", Элемент.Значение.ДатаНачала);
				Отбор.Вставить("ДатаОкончания", Элемент.Значение.ДатаОкончания);

			ИначеЕсли Раздел = "ФоновыеЗадания" Тогда
				Отбор.Вставить("Начало", Элемент.Значение.ДатаНачала);
				Отбор.Вставить("Конец", Элемент.Значение.ДатаОкончания);

			КонецЕсли;

		ИначеЕсли Элемент.Ключ = "Пользователь" Или Элемент.Ключ = "ВспомогательныйIPПорт" Или Элемент.Ключ = "ИмяПриложения"
			Или Элемент.Ключ = "Компьютер" Или Элемент.Ключ = "Метаданные" Или Элемент.Ключ = "ОсновнойIPПорт"
			Или Элемент.Ключ = "РабочийСервер" Или Элемент.Ключ = "Сеанс" Или Элемент.Ключ = "Событие" Тогда
			Отбор.Вставить(Элемент.Ключ, ?(ТипЗнч(Элемент.Значение) = Тип("СписокЗначений"),
				Элемент.Значение.ВыгрузитьЗначения(), Элемент.Значение));

		ИначеЕсли Элемент.Ключ = "МаксимальноеКоличество" Или Элемент.Ключ = "Данные" Или Элемент.Ключ = "ПредставлениеДанных"
			Или Элемент.Ключ = "Транзакция" Или Элемент.Ключ = "Транзакция" Или Элемент.Ключ = "ИмяМетода"
			Или Элемент.Ключ = "Ключ" Или Элемент.Ключ = "Наименование" Или Элемент.Ключ = "УникальныйИдентификатор" Тогда
			Отбор.Вставить(Элемент.Ключ, Элемент.Значение);

		ИначеЕсли Элемент.Ключ = "РегламентноеЗадание_УникальныйИдентификатор" Тогда
			Отбор.Вставить("РегламентноеЗадание", РегламентныеЗадания.НайтиПоУникальномуИдентификатору(
				Новый УникальныйИдентификатор(Элемент.Значение)));

		ИначеЕсли Элемент.Ключ = "СтатусТранзакции" Тогда
			Отбор.Вставить(Элемент.Ключ, Новый Массив);
			Для Каждого _ Из Элемент.Значение Цикл
				Отбор[Элемент.Ключ].Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации[_]);
			КонецЦикла;

		ИначеЕсли Элемент.Ключ = "Уровень" Тогда
			Отбор.Вставить(Элемент.Ключ, Новый Массив);
			Для Каждого _ Из Элемент.Значение Цикл
				Отбор[Элемент.Ключ].Добавить(УровеньЖурналаРегистрации[_]);
			КонецЦикла;

		ИначеЕсли Элемент.Ключ = "Состояние" Тогда
			Отбор.Вставить(Элемент.Ключ, Новый Массив);
			Для Каждого _ Из Элемент.Значение Цикл
				Отбор[Элемент.Ключ].Добавить(СостояниеФоновогоЗадания[_]);
			КонецЦикла;

		КонецЕсли;

	КонецЦикла;
	Если ПустаяСтрока(Локальные_Имя) Тогда
		Возврат Неопределено;
	Иначе
		Для Каждого Элемент Из Настройки.Структура Цикл
			ТипЭлемента = ТипЗнч(Элемент);
			Если (ТипЭлемента = Тип("ГруппировкаКомпоновкиДанных") Или ТипЭлемента = Тип(
				"ГруппировкаТаблицыКомпоновкиДанных") Или ТипЭлемента = Тип("ГруппировкаДиаграммыКомпоновкиДанных"))
				И Элемент.Имя = Локальные_Имя Тогда
				Возврат ?(Элемент.Использование, Отбор, Неопределено);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#Область Инициализация

Уровень = Новый Соответствие;
Уровень.Вставить(УровеньЖурналаРегистрации.Информация, "Информация");
Уровень.Вставить(УровеньЖурналаРегистрации.Ошибка, "Ошибка");
Уровень.Вставить(УровеньЖурналаРегистрации.Предупреждение, "Предупреждение");
Уровень.Вставить(УровеньЖурналаРегистрации.Примечание, "Предупреждение");

СтатусТранзакции = Новый Соответствие;
СтатусТранзакции.Вставить(СтатусТранзакцииЗаписиЖурналаРегистрации.Зафиксирована, "Зафиксирована");
СтатусТранзакции.Вставить(СтатусТранзакцииЗаписиЖурналаРегистрации.НеЗавершена, "НеЗавершена");
СтатусТранзакции.Вставить(СтатусТранзакцииЗаписиЖурналаРегистрации.НетТранзакции, "НетТранзакции");
СтатусТранзакции.Вставить(СтатусТранзакцииЗаписиЖурналаРегистрации.Отменена, "Отменена");

Состояние = Новый Соответствие;
Состояние.Вставить(СостояниеФоновогоЗадания.Активно, "Активно");
Состояние.Вставить(СостояниеФоновогоЗадания.Завершено, "Завершено");
Состояние.Вставить(СостояниеФоновогоЗадания.ЗавершеноАварийно, "ЗавершеноАварийно");
Состояние.Вставить(СостояниеФоновогоЗадания.Отменено, "Отменено");

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли