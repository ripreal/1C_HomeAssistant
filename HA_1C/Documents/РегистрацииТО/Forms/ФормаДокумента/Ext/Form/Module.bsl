﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Инициализировать();
	ПланТО = ТаблицаПланТО(Объект.Автомобиль, Объект.Дата);
	ОбновитьЭлементыПланаТО(ПланТО);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандРеквизитовФормы

#КонецОбласти

#Область ОбработчикиТЧРаботы

//Вызывается при первоначальном заполнении
&НаСервере
Процедура Инициализировать()
	
	Если Не ЗначениеЗаполнено(Объект.Автомобиль) Тогда
		Объект.Автомобиль = Справочники.Автомобили.АвтомобильПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыПланаТО(ПланТО)
	
	Счетчик = 1;
	Для каждого СтрокаПлана Из ПланТО Цикл
		ДобавитьСтрокуПланаТОНаФорму(СтрокаПлана, Счетчик);
		Счетчик = Счетчик + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РаботаОбработкаВыбора(Элемент, ВыбранноеЗначение) 
	
	//НомерХарактеристики = Элемент.Родитель.Родитель.ПодчиненныеЭлементы.Индекс(Элемент.Родитель) + 1;
	//
	//ИмяРеквизита = ФормыПроектыКлиентСервер.ИмяКолонкиЗначенияХарактеристики()+ НомерХарактеристики;
	//
	//КонвертированноеЧило = ПересчитатьЕдиницуИзмеренияНаСервере(
	//	ЭтотОбъект[Элемент.Имя], 
	//	ВыбранноеЗначение, 
	//	ЭтотОбъект[ИмяРеквизита]
	//);
	//
	//ЭтотОбъект[ИмяРеквизита] = КонвертированноеЧило;
	//
	//УстановитьТипХарактеристикиПоСсылке(ИмяРеквизита, ВыбранноеЗначение);
	//
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуПланаТОНаФорму(СтрокаТаблицы, Счетчик)
	
	МаксШирина = 10;
	
	РодительСтроки = ФормыОбщиеДействияСервер.НайтиДобавитьГруппуФормы(
		ЭтотОбъект, ИмяГруппыСтрокиТаблицы() + Счетчик, Элементы.ГруппаРаботы);
	РодительСтроки.Видимость   = Истина;
	РодительСтроки.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	
	РодительРаботы = ФормыОбщиеДействияСервер.НайтиДобавитьГруппуФормы(
		ЭтотОбъект, ИмяГруппыРодительРаботы() + Счетчик, РодительСтроки);
	
	// Добавляем Реквизиты для Ссылки на Регламентную работу
	ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
		ЭтотОбъект, ИмяРаботы() + Счетчик, СтрокаТаблицы.РегламентнаяРабота,
		РодительРаботы
	);
	ЭлементРеквизита.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	ЭлементРеквизита.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементРеквизита.РедактированиеТекста = Ложь;
	ЭлементРеквизита.УстановитьДействие("ОбработкаВыбора", "Подключаемый_РаботаОбработкаВыбора");
	
	// Добавление элемента для признака пройденого проекта
	ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
		ЭтотОбъект, ИмяВыполненннойРаботы() + Счетчик, 
		СтрокаТаблицы.СтатусТекущегоТО = Перечисления.СтатусыВыполненияТО.Пройдено,
		РодительРаботы
	);
	ЭлементРеквизита.Вид = ВидПоляФормы.ПолеФлажка;
	ЭлементРеквизита.ШиринаЭлемента = МаксШирина;
	ЭлементРеквизита.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	ЭлементРеквизита.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
	
	РодительРаботы = ФормыОбщиеДействияСервер.НайтиДобавитьГруппуФормы(
		ЭтотОбъект, ИмяГруппыРодительРаботы() + Счетчик, РодительСтроки);
		
	
	// Добавление элемента для текста прошлого ТО
	ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
		ЭтотОбъект, 
		ИмяПрошлогоТО() + Счетчик, 
		СтрШаблон(НСтр("ru = 'П:%1 / Ф:%2'; en = 'P:%1 / F:%2'"), 
			Формат(СтрокаТаблицы.ПрошлоеТОПоПлану, "ДФ=dd.MM.yy"),
			Формат(СтрокаТаблицы.ПрошлоеТОПоФакту, "ДФ=dd.MM.yy")),
		РодительСтроки
	);
	ЭлементРеквизита.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементРеквизита.ТолькоПросмотр = Истина;
	ЭлементРеквизита.Заголовок = НСтр("ru = 'Прошлое ТО'; en = 'Past'");
	
	// Добавление элемента для текста предстоящего ТО
	ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
		ЭтотОбъект, ИмяПредстоящегоТО() + Счетчик, 
		СтрШаблон(НСтр("ru = 'П:%1 / Ф:%2'; en = 'P:%1 / F:%2'"), 
			Формат(СтрокаТаблицы.ТекущееТОПоПлану, "ДФ=dd.MM.yy"),
			Формат(СтрокаТаблицы.ТекущееТОПоФакту, "ДФ=dd.MM.yy")),
		РодительСтроки
	);
	ЭлементРеквизита.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементРеквизита.ТолькоПросмотр = Истина;
	ЭлементРеквизита.Заголовок = НСтр("ru = 'Предстоящее ТО'; en = 'Next'");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТаблицаПланТО(Автомобиль, ДатаАнализа)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	АвтомобилиРегламентныеРаботы.РегламентнаяРабота КАК РегламентнаяРабота,
	|	МАКСИМУМ(ЕСТЬNULL(ЗарегистрированныеТО.Период, NULL)) КАК ПрошлоеТОПоФакту,
	|	ДОБАВИТЬКДАТЕ(ЕСТЬNULL(ЗарегистрированныеТО.Период, АвтомобилиРегламентныеРаботы.Ссылка.ДатаПриобретения), МЕСЯЦ, АвтомобилиРегламентныеРаботы.Интервал) КАК ТекущееТОПоФакту,
	|	ЗарегистрированныеТО.СтатусТО КАК СтатусТекущегоТО
	|ПОМЕСТИТЬ ТО_ФАКТ
	|ИЗ
	|	Справочник.Автомобили.РегламентныеРаботы КАК АвтомобилиРегламентныеРаботы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗарегистрированныеТО КАК ЗарегистрированныеТО
	|		ПО АвтомобилиРегламентныеРаботы.РегламентнаяРабота = ЗарегистрированныеТО.РегламентнаяРабота
	|			И АвтомобилиРегламентныеРаботы.Ссылка = ЗарегистрированныеТО.Автомобиль
	|			И (ЗарегистрированныеТО.Период <= &ДатаАнализа)
	|			И (ЗарегистрированныеТО.Период >= АвтомобилиРегламентныеРаботы.Ссылка.ДатаПриобретения)
	|ГДЕ
	|	АвтомобилиРегламентныеРаботы.Ссылка = &Автомобиль
	|
	|СГРУППИРОВАТЬ ПО
	|	АвтомобилиРегламентныеРаботы.Ссылка,
	|	АвтомобилиРегламентныеРаботы.РегламентнаяРабота,
	|	ЗарегистрированныеТО.СтатусТО,
	|	АвтомобилиРегламентныеРаботы.Интервал,
	|	ДОБАВИТЬКДАТЕ(ЕСТЬNULL(ЗарегистрированныеТО.Период, АвтомобилиРегламентныеРаботы.Ссылка.ДатаПриобретения), МЕСЯЦ, АвтомобилиРегламентныеРаботы.Интервал)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВлЗапрос.Интервал КАК Интервал,
	|	ВлЗапрос.РегламентнаяРабота КАК РегламентнаяРабота,
	|	ВлЗапрос.ДатаПриобретения КАК ДатаПриобретения,
	|	ДОБАВИТЬКДАТЕ(ВлЗапрос.ДатаПриобретения, МЕСЯЦ, ((ВЫРАЗИТЬ(ВлЗапрос.ТекущийНомерТО КАК ЧИСЛО(13, 0))) - 1) * ВлЗапрос.Интервал) КАК ПрошлоеТОПоПлану,
	|	ДОБАВИТЬКДАТЕ(ВлЗапрос.ДатаПриобретения, МЕСЯЦ, (ВЫРАЗИТЬ(ВлЗапрос.ТекущийНомерТО КАК ЧИСЛО(13, 0))) * ВлЗапрос.Интервал) КАК ТекущееТОПоПлану
	|ПОМЕСТИТЬ ТО_ПЛАН
	|ИЗ
	|	(ВЫБРАТЬ
	|		АвтомобилиРегламентныеРаботы.Интервал КАК Интервал,
	|		АвтомобилиРегламентныеРаботы.РегламентнаяРабота КАК РегламентнаяРабота,
	|		АвтомобилиРегламентныеРаботы.Ссылка.ДатаПриобретения КАК ДатаПриобретения,
	|		ВЫРАЗИТЬ(РАЗНОСТЬДАТ(АвтомобилиРегламентныеРаботы.Ссылка.ДатаПриобретения, &ДатаАнализа, МЕСЯЦ) / АвтомобилиРегламентныеРаботы.Интервал КАК ЧИСЛО(10, 9)) КАК ТекущийНомерТО
	|	ИЗ
	|		Справочник.Автомобили.РегламентныеРаботы КАК АвтомобилиРегламентныеРаботы
	|	ГДЕ
	|		АвтомобилиРегламентныеРаботы.Ссылка = &Автомобиль) КАК ВлЗапрос
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТО_ПЛАН.РегламентнаяРабота КАК РегламентнаяРабота,
	|	ТО_ПЛАН.ПрошлоеТОПоПлану КАК ПрошлоеТОПоПлану,
	|	ТО_ФАКТ.ПрошлоеТОПоФакту КАК ПрошлоеТОПоФакту,
	|	ТО_ПЛАН.ТекущееТОПоПлану КАК ТекущееТОПоПлану,
	|	ТО_ФАКТ.ТекущееТОПоФакту КАК ТекущееТОПоФакту,
	|	ТО_ФАКТ.СтатусТекущегоТО КАК СтатусТекущегоТО
	|ИЗ
	|	ТО_ФАКТ КАК ТО_ФАКТ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТО_ПЛАН КАК ТО_ПЛАН
	|		ПО ТО_ФАКТ.РегламентнаяРабота = ТО_ПЛАН.РегламентнаяРабота");
	Запрос.УстановитьПараметр("Автомобиль", Автомобиль);
	Запрос.УстановитьПараметр("ДатаАнализа", ДатаАнализа);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяГруппыСтрокиТаблицы()
	
	Возврат "ГруппаСтрокаТаб";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяГруппыРодительРаботы()
	
	Возврат "ГруппаРаботаСтрока";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяРаботы()
	
	Возврат "Работа";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяВыполненннойРаботы()
	
	Возврат "РаботаВыполнена";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяПрошлогоТО()
	
	Возврат "ПрошлоеТО";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяПредстоящегоТО()
	
	Возврат "ПредстоящееТО";
	
КонецФункции



#КонецОбласти
