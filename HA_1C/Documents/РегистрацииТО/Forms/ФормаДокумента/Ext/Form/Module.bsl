﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Инициализировать();
	ЗагрузитьТаблицуСПланомТО();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандРеквизитовФормы

&НаКлиенте
Процедура Подключаемый_ИзменитьСтатусТО(Элемент) Экспорт
	
	НомерСтроки = НомерСтрокиИзИмениЭлемента(Элемент.Имя);
	
	РегламентныеРаботы[НомерСтроки - 1].СтатусТекущегоТО = ?(ЭтотОбъект[Элемент.Имя],
		ПредопределенноеЗначение("Перечисление.СтатусыВыполненияТО.Пройдено"),
		ПредопределенноеЗначение("Перечисление.СтатусыВыполненияТО.НеПройдено")
	);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобильПриИзменении(Элемент)
	ЗагрузитьТаблицуСПланомТО();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ЗагрузитьТаблицуСПланомТО();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТЧРаботы

//Вызывается при первоначальном заполнении
&НаСервере
Процедура Инициализировать()
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Не ЗначениеЗаполнено(Объект.Автомобиль) Тогда
			Объект.Автомобиль = Справочники.Автомобили.АвтомобильПоУмолчанию();
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.Дата) Тогда
			Объект.Дата = ТекущаяДата();
		КонецЕсли;
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
	
	// Флажок пройденого проекта
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
		
	ЭлементРеквизита.УстановитьДействие("ПриИзменении", "Подключаемый_ИзменитьСтатусТО");
	
	// Текст прошлого ТО
	ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
		ЭтотОбъект, 
		ИмяПрошлогоТО() + Счетчик, 
		ПредставлениеСтрокиПланФакта(СтрокаТаблицы.ПрошлоеТОПоПлану, СтрокаТаблицы.ПрошлоеТОПоФакту),
		РодительСтроки,
		Тип("ФорматированнаяСтрока")
	);
	ЭлементРеквизита.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементРеквизита.ТолькоПросмотр = Истина;
	ЭлементРеквизита.Заголовок = НСтр("ru = 'Прошлое ТО'; en = 'Past'");
	
	// Добавление элемента для текста предстоящего ТО
	ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
		ЭтотОбъект, ИмяПредстоящегоТО() + Счетчик,
		ПредставлениеСтрокиПланФакта(СтрокаТаблицы.ТекущееТОПоПлану, СтрокаТаблицы.ТекущееТОПоФакту),
		РодительСтроки,
		Тип("ФорматированнаяСтрока")
	);
	ЭлементРеквизита.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементРеквизита.ТолькоПросмотр = Истина;
	ЭлементРеквизита.Заголовок = НСтр("ru = 'Предстоящее ТО'; en = 'Next'");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеСтрокиПланФакта(ПланДата, ФактДата)
	
	СтрокаПлана = Новый ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = 'П:%1'; en = 'P:%1'"), Формат(ПланДата, "ДФ=dd.MM.yy; ДП='--------------'")),
		, Новый Цвет(0, 0, 150));
		
	Разделитель = Новый ФорматированнаяСтрока(" / ");
		
	СтрокаФакта = Новый ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = 'Ф:%1'; en = 'F:%1'"), Формат(ФактДата, "ДФ=dd.MM.yy; ДП='--------------'")),
		, Новый Цвет(0, 150, 0));
	
	Возврат Новый ФорматированнаяСтрока(СтрокаПлана, Разделитель, СтрокаФакта);
	
КонецФункции

&НаСервереБезКонтекста
Функция ТаблицаПланТО(Автомобиль, ДатаАнализа)
	
	Проверки.СвойствоЗаполнено(Автомобиль);
	Проверки.СвойствоЗаполнено(ДатаАнализа);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	АвтомобилиРегламентныеРаботы.РегламентнаяРабота КАК РегламентнаяРабота,
	|	МАКСИМУМ(ЕСТЬNULL(ЗарегистрированныеТО.Период, NULL)) КАК ПрошлоеТОПоФакту,
	|	ДОБАВИТЬКДАТЕ(ЗарегистрированныеТО.Период, МЕСЯЦ, АвтомобилиРегламентныеРаботы.Интервал) КАК ТекущееТОПоФакту,
	|	ЕСТЬNULL(ЗарегистрированныеТО.СтатусТО, ЗНАЧЕНИЕ(Перечисление.СтатусыВыполненияТО.НеПройдено)) КАК СтатусТекущегоТО
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
	|	ДОБАВИТЬКДАТЕ(ЗарегистрированныеТО.Период, МЕСЯЦ, АвтомобилиРегламентныеРаботы.Интервал)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВлЗапрос.Интервал КАК Интервал,
	|	ВлЗапрос.РегламентнаяРабота КАК РегламентнаяРабота,
	|	ВлЗапрос.ДатаПриобретения КАК ДатаПриобретения,
	|	ВЫБОР
	|		КОГДА РАЗНОСТЬДАТ(ВлЗапрос.ДатаПриобретения, &ДатаАнализа, МЕСЯЦ) < ВлЗапрос.Интервал
	|			ТОГДА NULL
	|		ИНАЧЕ ВлЗапрос.ПрошлоеТОПоПлану
	|	КОНЕЦ КАК ПрошлоеТОПоПлану,
	|	ВлЗапрос.ТекущийНомерТО КАК ТекущийНомерТО,
	|	ВЫБОР
	|		КОГДА ВлЗапрос.ТекущийНомерТО = 0
	|			ТОГДА ДОБАВИТЬКДАТЕ(ВлЗапрос.ДатаПриобретения, МЕСЯЦ, ВлЗапрос.Интервал)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ВлЗапрос.ДатаПриобретения, МЕСЯЦ, ВлЗапрос.ТекущийНомерТО * ВлЗапрос.Интервал)
	|	КОНЕЦ КАК ТекущееТОПоПлану
	|ПОМЕСТИТЬ ТО_ПЛАН
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВлЗапрос.Интервал КАК Интервал,
	|		ВлЗапрос.РегламентнаяРабота КАК РегламентнаяРабота,
	|		ВлЗапрос.ДатаПриобретения КАК ДатаПриобретения,
	|		ДОБАВИТЬКДАТЕ(ВлЗапрос.ДатаПриобретения, МЕСЯЦ, (ВлЗапрос.ТекущийНомерТО) * ВлЗапрос.Интервал) КАК ПрошлоеТОПоПлану,
	|		ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(ВлЗапрос.ТекущийНомерТО КАК ЧИСЛО(13, 0))) = ВлЗапрос.ТекущийНомерТО
	|				ТОГДА ВлЗапрос.ТекущийНомерТО
	|			ИНАЧЕ ВЫРАЗИТЬ(ВлЗапрос.ТекущийНомерТО + 0.5 КАК ЧИСЛО(13, 0))
	|		КОНЕЦ КАК ТекущийНомерТО
	|	ИЗ
	|		(ВЫБРАТЬ
	|			АвтомобилиРегламентныеРаботы.Интервал КАК Интервал,
	|			АвтомобилиРегламентныеРаботы.РегламентнаяРабота КАК РегламентнаяРабота,
	|			АвтомобилиРегламентныеРаботы.Ссылка.ДатаПриобретения КАК ДатаПриобретения,
	|			ВЫРАЗИТЬ(РАЗНОСТЬДАТ(АвтомобилиРегламентныеРаботы.Ссылка.ДатаПриобретения, &ДатаАнализа, МЕСЯЦ) / АвтомобилиРегламентныеРаботы.Интервал КАК ЧИСЛО(10, 3)) КАК ТекущийНомерТО
	|		ИЗ
	|			Справочник.Автомобили.РегламентныеРаботы КАК АвтомобилиРегламентныеРаботы
	|		ГДЕ
	|			АвтомобилиРегламентныеРаботы.Ссылка = &Автомобиль) КАК ВлЗапрос) КАК ВлЗапрос
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТО_ПЛАН.РегламентнаяРабота КАК РегламентнаяРабота,
	|	ТО_ПЛАН.ПрошлоеТОПоПлану КАК ПрошлоеТОПоПлану,
	|	ТО_ФАКТ.ПрошлоеТОПоФакту КАК ПрошлоеТОПоФакту,
	|	ТО_ПЛАН.ТекущееТОПоПлану КАК ТекущееТОПоПлану,
	|	ТО_ФАКТ.СтатусТекущегоТО КАК СтатусТекущегоТО,
	|	ТО_ФАКТ.ТекущееТОПоФакту КАК ТекущееТОПоФакту
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

&НаСервере
Процедура ЗагрузитьТаблицуСПланомТО()
	
	Если ЗначениеЗаполнено(Объект.Автомобиль) И ЗначениеЗаполнено(Объект.Дата) Тогда
		РегламентныеРаботы.Загрузить(ТаблицаПланТО(Объект.Автомобиль, Объект.Дата));
	КонецЕсли;
	
	ОбновитьЭлементыПланаТО(РегламентныеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НомерСтрокиИзИмениЭлемента(ИмяЭлемента)
	
	Проверки.СвойствоЗаполнено(ИмяЭлемента);
	
	Возврат Прав(ИмяЭлемента, 1);
	
КонецФункции

#КонецОбласти