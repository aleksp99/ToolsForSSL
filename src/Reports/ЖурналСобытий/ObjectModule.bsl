#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
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
	
	Настройки.Вставить("РазрешеноВыбиратьИНастраиватьВариантыБезСохранения", Истина);
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
		Не (ВнешниеНаборыДанных.ЖурналРегистрации.Количество() Или ВнешниеНаборыДанных.ФоновыеЗадания.Количество()));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЖурналРегистрации(Настройки)

 	Таблица = ПустаяТаблицаНабораДанных("ЖурналРегистрации");
 	ЗаПоследние = ОтчетыКлиентСервер.НайтиПараметр(Настройки, , "ЗаПоследние").Значение;
 	ЗаПоследние = ?(ЗаПоследние, ЗаПоследние * 60, 0);	
	Период = ?(ЗаПоследние,
		Новый Структура("ДатаНачала,ДатаОкончания", ТекущаяДата() - ЗаПоследние, ТекущаяДата() + 1800),
		ОтчетыКлиентСервер.НайтиПараметр(Настройки, , "ЖурналРегистрации_СтандартныйПериод").Значение);
	МаксКоличество = ОтчетыКлиентСервер.НайтиПараметр(Настройки,, "ЖурналРегистрации_МаксимальноеКоличество").Значение;
	Если Не МаксКоличество Тогда 
		Возврат Таблица;
	КонецЕсли;
	
	Отборы = ПолучитьОтборы(Настройки.Отбор.Элементы, "ЖурналРегистрации");
	Если Не Отборы.Количество() Тогда 
		Возврат Таблица;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ДатаНачала", Период.ДатаНачала);
	Отбор.Вставить("ДатаОкончания", Период.ДатаОкончания);
	Для Каждого Элемент Из Отборы Цикл 
		
		Ключ = Сред(Элемент.ЛевоеЗначение, 19);
		
		Если Не (Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно 
					Или (Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке 
							И Не (Ключ  = "Данные" Или Ключ  = "Комментарий" Или Ключ  = "Транзакция"))) Тогда 
			ВызватьИсключение НСтр("ru = 'Вид сравнения элемент отбора не поддерживается'");
		КонецЕсли;
		
		Если Ключ = "Данные" Тогда
			Отбор.Вставить(Ключ, Элемент.ПравоеЗначение);
			
		ИначеЕсли Ключ = "Комментарий" Тогда
			Отбор.Вставить(Ключ, Элемент.ПравоеЗначение);
			
		ИначеЕсли Ключ = "Транзакция" Тогда
			Отбор.Вставить("Транзакция", Элемент.ПравоеЗначение);
			
		ИначеЕсли Ключ = "IPПорт.Вспомогательный" Тогда
			ДобавитьЗначениеОтбора(Отбор, "ВспомогательныйIPПорт", Элемент.ВидСравнения, Элемент.ПравоеЗначение);
			
		ИначеЕсли Ключ = "IPПорт.Основной" Тогда
			ДобавитьЗначениеОтбора(Отбор, "ОсновнойIPПорт", Элемент.ВидСравнения, Элемент.ПравоеЗначение);
			
		ИначеЕсли Ключ = "Метаданные" Тогда
			ДобавитьЗначениеОтбора(Отбор, Ключ, Элемент.ВидСравнения, Метаданные.НайтиПоПолномуИмени(Элемент.ПравоеЗначение));
			
		ИначеЕсли Ключ = "Пользователь" Тогда
			ДобавитьЗначениеОтбора(Отбор, Ключ, Элемент.ВидСравнения, ПользователиИнформационнойБазы.НайтиПоИмени(Элемент.ПравоеЗначение));
			
		ИначеЕсли Ключ = "Пользователь.Идентификатор" Тогда
			ДобавитьЗначениеОтбора(Отбор, "Пользователь", Элемент.ВидСравнения, ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Элемент.ПравоеЗначение));
			
		ИначеЕсли Ключ = "Приложение" Тогда
			ДобавитьЗначениеОтбора(Отбор, "ИмяПриложения", Элемент.ВидСравнения, Элемент.ПравоеЗначение);
			
		ИначеЕсли Ключ = "Компьютер" Или Ключ = "РабочийСервер" Или Ключ = "Сеанс" Или Ключ = "Событие" Тогда
			ДобавитьЗначениеОтбора(Отбор, Ключ, Элемент.ВидСравнения, Элемент.ПравоеЗначение);
			
		ИначеЕсли Ключ = "Транзакция.Статус" Тогда
			ДобавитьЗначениеОтбора(Отбор, "СтатусТранзакции", Элемент.ВидСравнения, СтатусТранзакцииЗаписиЖурналаРегистрации(Элемент.ПравоеЗначение));
			
		ИначеЕсли Ключ = "Уровень" Тогда
			ДобавитьЗначениеОтбора(Отбор, Ключ, Элемент.ВидСравнения, УровеньЖурналаРегистрации(Элемент.ПравоеЗначение));
			
		Иначе 
			ВызватьИсключение НСтр("ru = 'Элемент отбора неопределен'");
		КонецЕсли;
		
	КонецЦикла;
	
	ВыгрузитьЖурналРегистрации(Таблица, Отбор,,, МаксКоличество);
	Для Каждого Элемент Из Таблица Цикл 
		Элемент.Уровень = УровеньЖурналаРегистрации(Элемент.Уровень);
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

Функция ФоновыеЗадания(Настройки)
	
	Таблица = ПустаяТаблицаНабораДанных("ФоновыеЗадания");
	ЗаПоследние = ОтчетыКлиентСервер.НайтиПараметр(Настройки, , "ЗаПоследние").Значение;
	ЗаПоследние = ?(ЗаПоследние, ЗаПоследние * 60, 0);
	Отборы = ПолучитьОтборы(Настройки.Отбор.Элементы, "ФоновыеЗадания");
	Если Не Отборы.Количество() Тогда 
		Возврат Таблица;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Для Каждого Элемент Из Отборы Цикл 
		
		Ключ = Сред(Элемент.ЛевоеЗначение, 16);
		Если Не (Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно 
					Или (Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке И Ключ  = "Состояние")) Тогда 
			ВызватьИсключение НСтр("ru = 'Вид сравнения элемент отбора не поддерживается'");
		КонецЕсли;
		Если Ключ = "ИмяМетода" Или Ключ = "Ключ" Или Ключ = "Наименование" Или Ключ = "УникальныйИдентификатор" Тогда
			Отбор.Вставить(Ключ, Элемент.ПравоеЗначение);
			
		ИначеЕсли Ключ = "Начало" Тогда
			Отбор.Вставить(Ключ, ?(ЗаПоследние, ТекущаяДата() - ЗаПоследние, Элемент.ПравоеЗначение));
			
		ИначеЕсли Ключ = "Конец" Тогда
			  Отбор.Вставить(Ключ, ?(ЗаПоследние, ТекущаяДата() + 1800, Элемент.ПравоеЗначение));
			
		ИначеЕсли Ключ = "Состояние" Тогда
			ДобавитьЗначениеОтбора(Отбор, Ключ, Элемент.ВидСравнения, СостояниеФоновогоЗадания(Элемент.ПравоеЗначение));
			
		ИначеЕсли СтрНачинаетсяС(Ключ, "РегламентноеЗадание.") Тогда 
			Если Ключ = "РегламентноеЗадание.Метаданные" Тогда
				Значение = Метаданные.НайтиПоПолномуИмени(Элемент.ПравоеЗначение);
			ИначеЕсли Ключ = "РегламентноеЗадание.Наименование" Тогда
				Значение = Метаданные.РегламентныеЗадания.Найти(Элемент.ПравоеЗначение);
			Иначе 
				ВызватьИсключение НСтр("ru = 'Элемент отбора неопределен'");
			КонецЕсли;
			Если Значение = Неопределено Тогда 
				ВызватьИсключение НСтр("ru = 'Значение отбора неопределено'");
			КонецЕсли;
			Если Отбор.Свойство("РегламентноеЗадание") Тогда 
				Если Отбор.РегламентноеЗадание = Значение Тогда
					ВызватьИсключение НСтр("ru = 'Конфликт значений отбора'");
				КонецЕсли;
			Иначе 
				Отбор.Вставить("РегламентноеЗадание", Значение);
			КонецЕсли;
			
		Иначе 
			ВызватьИсключение НСтр("ru = 'Элемент отбора неопределен'");
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Элемент Из ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор) Цикл 
		
		НоваяСтрока = Таблица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Элемент);
		Если Не Элемент.ИнформацияОбОшибке = Неопределено Тогда 
			НоваяСтрока.ИнформацияОбОшибке_ИмяМодуля = Элемент.ИнформацияОбОшибке.ИмяМодуля;
			НоваяСтрока.ИнформацияОбОшибке_ИсходнаяСтрока = Элемент.ИнформацияОбОшибке.ИсходнаяСтрока;
			НоваяСтрока.ИнформацияОбОшибке_НомерСтроки = Элемент.ИнформацияОбОшибке.НомерСтроки;
			НоваяСтрока.ИнформацияОбОшибке_Описание = Элемент.ИнформацияОбОшибке.Описание;
			НоваяСтрока.ИнформацияОбОшибке_Причина = ?(Элемент.ИнформацияОбОшибке.Причина = Неопределено, "", ПодробноеПредставлениеОшибки(Элемент.ИнформацияОбОшибке.Причина));
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
		Если Элемент.Состояние = СостояниеФоновогоЗадания.Активно Тогда 
			НоваяСтрока.Состояние = 1;
		ИначеЕсли Элемент.Состояние = СостояниеФоновогоЗадания.Завершено Тогда 
			НоваяСтрока.Состояние = 2;
		ИначеЕсли Элемент.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда 
			НоваяСтрока.Состояние = 3;
		ИначеЕсли Элемент.Состояние = СостояниеФоновогоЗадания.Отменено Тогда 
			НоваяСтрока.Состояние = 4;
		КонецЕсли;
		
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

Функция ПолучитьОтборы(Элементы, Ключ)
	
	Отборы = Новый Массив;
	Для Каждого Элемент Из Элементы Цикл 
		
		Если Не Элемент.Использование Тогда 
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(Элемент) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда 
			Если СтрНачинаетсяС(Элемент.ЛевоеЗначение, Ключ + ".") Тогда 
				Отборы.Добавить(Элемент);
			КонецЕсли;
		Иначе 
			ВызватьИсключение НСтр("ru = 'Тип элемента отбора не поддерживается'");
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Отборы;
	
КонецФункции

Процедура ДобавитьЗначениеОтбора(Отбор, Ключ, ВидСравнения, Значение)
	
	Если Значение = Неопределено Тогда 
		ВызватьИсключение НСтр("ru = 'Значение отбора неопределено'");
	КонецЕсли;
	Если Не Отбор.Свойство("Состояние") Тогда 
		Отбор.Вставить("Состояние", Новый Массив);
	КонецЕсли;
	Если ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда 
		Отбор.Состояние.Добавить(Значение);
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда 
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Отбор.Состояние, ?(ТипЗнч(Значение) = Тип("СписокЗначений"), Значение.ВыгрузитьЗначения(), Значение), Истина);
	Иначе 
		ВызватьИсключение НСтр("ru = 'Вид сравнения элемент отбора не поддерживается'");
	КонецЕсли;
	
КонецПроцедуры

Функция СостояниеФоновогоЗадания(Ключ)
	
	Если ТипЗнч(Ключ) = Тип("СписокЗначений") Тогда 
		Возврат СоответствиеСписока(Ключ, "СостояниеФоновогоЗадания");
	КонецЕсли;
	
	Массив = Новый Массив;
	Массив.Добавить(СостояниеФоновогоЗадания.Активно);
	Массив.Добавить(СостояниеФоновогоЗадания.Завершено);
	Массив.Добавить(СостояниеФоновогоЗадания.ЗавершеноАварийно);
	Массив.Добавить(СостояниеФоновогоЗадания.Отменено);
	
	Возврат ?(ТипЗнч(Ключ) = Тип("Число"), Массив.Получить(Ключ), Массив.Найти(Ключ));
	
КонецФункции

Функция УровеньЖурналаРегистрации(Ключ) 
	
	Если ТипЗнч(Ключ) = Тип("СписокЗначений") Тогда 
		Возврат СоответствиеСписока(Ключ, "УровеньЖурналаРегистрации");
	КонецЕсли;
	
	Массив = Новый Массив;
	Массив.Добавить(УровеньЖурналаРегистрации.Информация);
	Массив.Добавить(УровеньЖурналаРегистрации.Ошибка);
	Массив.Добавить(УровеньЖурналаРегистрации.Предупреждение);
	Массив.Добавить(УровеньЖурналаРегистрации.Примечание);
	
	Возврат ?(ТипЗнч(Ключ) = Тип("Число"), Массив.Получить(Ключ), Массив.Найти(Ключ));
	
КонецФункции

Функция СтатусТранзакцииЗаписиЖурналаРегистрации(Ключ) 
	
	Если ТипЗнч(Ключ) = Тип("СписокЗначений") Тогда 
		Возврат СоответствиеСписока(Ключ, "СтатусТранзакцииЗаписиЖурналаРегистрации");
	КонецЕсли;
	
	Массив = Новый Массив;
	Массив.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.Зафиксирована);
	Массив.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.НеЗавершена);
	Массив.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.НетТранзакции);
	Массив.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.Отменена);
	
	Возврат ?(ТипЗнч(Ключ) = Тип("Число"), Массив.Получить(Ключ), Массив.Найти(Ключ));
	
КонецФункции

Функция СоответствиеСписока(Список, ИмяМетода)
	
	Результат = Новый Массив;
	Для Каждого Элемент Из Список Цикл 
		Результат.Добавить(Вычислить(ИмяМетода + "(" + Элемент.Значение + ")"));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли