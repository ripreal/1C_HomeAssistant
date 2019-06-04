﻿

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Представление = СтрШаблон(НСтр("ru = 'Ремонт авто от %1'; en = 'Repair dated %1'"), 
		Формат(Данные.Дата, "ДФ=dd/MM/yyyy"));
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьВидыВР() Экспорт
	
	ВидыТО = Новый Массив;
	ВидыТО.Добавить(ИмяТекущееВР());
	Возврат ВидыТО;
	
КонецФункции

Функция ИмяПрошлогоВР() Экспорт
	
	Возврат "ПрошлоеВР";
	
КонецФункции

Функция ИмяТекущееВР() Экспорт
	
	Возврат "ТекущееВР";
	
КонецФункции

Функция ИмяСледующееВР() Экспорт
	
	Возврат "СледующееВР";
	
КонецФункции

Функция ТаблицаВнеплановыхТО(ДатаАнализа, Автомобиль = Неопределено) Экспорт
	
	Проверки.СвойствоЗаполнено(ДатаАнализа);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТекущиеДанныеТО.ТекущийНомерТО КАК ТекущийНомерТО,
	|	ТекущиеДанныеТО.ДатаПриобретенияАвто КАК ДатаПриобретенияАвто,
	|	ТекущиеДанныеТО.ТекущийНомерТО - 1 КАК ПрошлоеТОНомер,
	|	ДОБАВИТЬКДАТЕ(ТекущиеДанныеТО.ДатаПриобретенияАвто, МЕСЯЦ, 12 * (ТекущиеДанныеТО.ТекущийНомерТО - 1)) КАК ПрошлоеТОПоПлану,
	|	ТекущиеДанныеТО.ТекущийНомерТО КАК ТекущееТОНомер,
	|	ДОБАВИТЬКДАТЕ(ТекущиеДанныеТО.ДатаПриобретенияАвто, МЕСЯЦ, 12 * ТекущиеДанныеТО.ТекущийНомерТО) КАК ТекущееТОПоПлану,
	|	ТекущиеДанныеТО.ТекущийНомерТО + 1 КАК СледующееТОНомер,
	|	ДОБАВИТЬКДАТЕ(ТекущиеДанныеТО.ДатаПриобретенияАвто, МЕСЯЦ, 12 * (ТекущиеДанныеТО.ТекущийНомерТО + 1)) КАК СледующееТОПоПлану,
	|	ТекущиеДанныеТО.Автомобиль КАК Автомобиль
	|ПОМЕСТИТЬ ИнтервалыПлан
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(ВлЗапрос.ТекущийНомерТО КАК ЧИСЛО(13, 0))) = ВлЗапрос.ТекущийНомерТО
	|				ТОГДА ВлЗапрос.ТекущийНомерТО
	|			ИНАЧЕ ВЫРАЗИТЬ(ВлЗапрос.ТекущийНомерТО - 0.5 КАК ЧИСЛО(13, 0))
	|		КОНЕЦ КАК ТекущийНомерТО,
	|		ВлЗапрос.ДатаПриобретенияАвто КАК ДатаПриобретенияАвто,
	|		ВлЗапрос.Автомобиль КАК Автомобиль
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ВЫРАЗИТЬ(РАЗНОСТЬДАТ(Автомобили.ДатаПриобретения, &ДатаАнализа, МЕСЯЦ) / 12 КАК ЧИСЛО(10, 3)) КАК ТекущийНомерТО,
	|			Автомобили.ДатаПриобретения КАК ДатаПриобретенияАвто,
	|			Автомобили.Ссылка КАК Автомобиль
	|		ИЗ
	|			Справочник.Автомобили КАК Автомобили
	|		ГДЕ
	|			Автомобили.Ссылка = &Автомобиль) КАК ВлЗапрос) КАК ТекущиеДанныеТО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИнтервалыПлан.ПрошлоеТОНомер КАК ПрошлоеТОНомер,
	|	ИнтервалыПлан.ТекущееТОНомер КАК ТекущееТОНомер,
	|	ИнтервалыПлан.СледующееТОНомер КАК СледующееТОНомер,
	|	ВЫБОР
	|		КОГДА ЗарегистрированныеВР.Период >= ИнтервалыПлан.ПрошлоеТОПоПлану
	|				И ЗарегистрированныеВР.Период < ИнтервалыПлан.ТекущееТОПоПлану
	|			ТОГДА ЗарегистрированныеВР.Период
	|	КОНЕЦ КАК ПрошлоеВРПериод,
	|	ВЫБОР
	|		КОГДА ЗарегистрированныеВР.Период >= ИнтервалыПлан.ТекущееТОПоПлану
	|				И ЗарегистрированныеВР.Период < ИнтервалыПлан.СледующееТОПоПлану
	|			ТОГДА ЗарегистрированныеВР.Период
	|	КОНЕЦ КАК ТекущееВРПериод,
	|	ВЫБОР
	|		КОГДА ЗарегистрированныеВР.Период >= ИнтервалыПлан.СледующееТОПоПлану
	|				И ЗарегистрированныеВР.Период < ДОБАВИТЬКДАТЕ(ИнтервалыПлан.СледующееТОПоПлану, МЕСЯЦ, 12)
	|			ТОГДА ЗарегистрированныеВР.Период
	|	КОНЕЦ КАК СледующееВРПериод,
	|	ВЫБОР
	|		КОГДА ЗарегистрированныеВР.Период >= ИнтервалыПлан.ПрошлоеТОПоПлану
	|				И ЗарегистрированныеВР.Период < ИнтервалыПлан.ТекущееТОПоПлану
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыВыполненияТО.Пройдено)
	|	КОНЕЦ КАК ПрошлоеВРСтатус,
	|	ВЫБОР
	|		КОГДА ЗарегистрированныеВР.Период >= ИнтервалыПлан.ТекущееТОПоПлану
	|				И ЗарегистрированныеВР.Период < ИнтервалыПлан.СледующееТОПоПлану
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыВыполненияТО.Пройдено)
	|	КОНЕЦ КАК ТекущееВРСтатус,
	|	ВЫБОР
	|		КОГДА ЗарегистрированныеВР.Период >= ИнтервалыПлан.СледующееТОПоПлану
	|				И ЗарегистрированныеВР.Период < ДОБАВИТЬКДАТЕ(ИнтервалыПлан.СледующееТОПоПлану, МЕСЯЦ, 12)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыВыполненияТО.Пройдено)
	|	КОНЕЦ КАК СледующееВРСтатус,
	|	ВЫБОР
	|		КОГДА ЗарегистрированныеВР.Период >= ИнтервалыПлан.ПрошлоеТОПоПлану
	|				И ЗарегистрированныеВР.Период < ИнтервалыПлан.ТекущееТОПоПлану
	|			ТОГДА ЗарегистрированныеВР.Сумма
	|	КОНЕЦ КАК ПрошлоеВРСумма,
	|	ВЫБОР
	|		КОГДА ЗарегистрированныеВР.Период >= ИнтервалыПлан.ТекущееТОПоПлану
	|				И ЗарегистрированныеВР.Период < ИнтервалыПлан.СледующееТОПоПлану
	|			ТОГДА ЗарегистрированныеВР.Сумма
	|	КОНЕЦ КАК ТекущееВРСумма,
	|	ВЫБОР
	|		КОГДА ЗарегистрированныеВР.Период >= ИнтервалыПлан.СледующееТОПоПлану
	|				И ЗарегистрированныеВР.Период < ДОБАВИТЬКДАТЕ(ИнтервалыПлан.СледующееТОПоПлану, МЕСЯЦ, 12)
	|			ТОГДА ЗарегистрированныеВР.Сумма
	|	КОНЕЦ КАК СледующееВРСумма,
	|	ВЫБОР
	|		КОГДА ЗарегистрированныеВР.Период >= ИнтервалыПлан.ПрошлоеТОПоПлану
	|				И ЗарегистрированныеВР.Период < ИнтервалыПлан.ТекущееТОПоПлану
	|			ТОГДА ЗарегистрированныеВР.Идентификатор
	|	КОНЕЦ КАК ПрошлоеВРИдентификатор,
	|	ВЫБОР
	|		КОГДА ЗарегистрированныеВР.Период >= ИнтервалыПлан.ТекущееТОПоПлану
	|				И ЗарегистрированныеВР.Период < ИнтервалыПлан.СледующееТОПоПлану
	|			ТОГДА ЗарегистрированныеВР.Идентификатор
	|	КОНЕЦ КАК ТекущееВРИдентификатор,
	|	ВЫБОР
	|		КОГДА ЗарегистрированныеВР.Период >= ИнтервалыПлан.СледующееТОПоПлану
	|				И ЗарегистрированныеВР.Период < ДОБАВИТЬКДАТЕ(ИнтервалыПлан.СледующееТОПоПлану, МЕСЯЦ, 12)
	|			ТОГДА ЗарегистрированныеВР.Идентификатор
	|	КОНЕЦ КАК СледующееВРИдентификатор,
	|	ЗарегистрированныеВР.Автомобиль КАК Автомобиль,
	|	ЗарегистрированныеВР.РегламентнаяРабота КАК РегламентнаяРабота
	|ИЗ
	|	ИнтервалыПлан КАК ИнтервалыПлан,
	|	РегистрСведений.ЗарегистрированныеВР КАК ЗарегистрированныеВР");
	Запрос.УстановитьПараметр("Автомобиль", Автомобиль);
	Запрос.УстановитьПараметр("ДатаАнализа", ДатаАнализа);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПривестиТаблицуРаботКАктуальномуПериоду(ВыполненныеРаботы, ДатаАнализа) Экспорт
	
	ВидыВР = ПолучитьВидыВР();
	
	РеквизитыАктуализации = Новый Массив;
	Для каждого РеквизитТЧ Из Метаданные.Документы.ВнеплановыеРаботы.ТабличныеЧасти.ВыполненныеРаботы.Реквизиты Цикл
		НайденныйВидВР = УзнатьВидТОПоИмениЭлемента(РеквизитТЧ.Имя);
		Если НайденныйВидВР <> Неопределено Тогда
			СокрИмяРеквизита = СтрЗаменить(РеквизитТЧ.Имя, НайденныйВидВР, "");
			Если РеквизитыАктуализации.Найти(СокрИмяРеквизита) = Неопределено Тогда
				РеквизитыАктуализации.Добавить(СокрИмяРеквизита);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ВыполненныеРаботыПриведенная = ВыполненныеРаботы.Скопировать();
	Для Счетчик = 0 По ВыполненныеРаботы.Количество() - 1 Цикл
		Для каждого ВидВР Из ВидыВР Цикл
			ПеренестиЗначенияРеквизитов(РеквизитыАктуализации, ВыполненныеРаботы[Счетчик], ВидВР, ДатаАнализа, ВыполненныеРаботыПриведенная, Счетчик)
		КонецЦикла;
	КонецЦикла;
	
	ВсеРеквизитыТЧ = Новый Массив;
	Для каждого РеквизитТЧ Из Метаданные.Документы.ВнеплановыеРаботы.ТабличныеЧасти.ВыполненныеРаботы.Реквизиты Цикл
		ВсеРеквизитыТЧ.Добавить(РеквизитТЧ.Имя);
	КонецЦикла;
	
	ВыполненныеРаботыПриведенная.Свернуть(СтрСоединить(ВсеРеквизитыТЧ, ","));
	
	Возврат ВыполненныеРаботыПриведенная;
	
КонецФункции

Функция ДатаТОПоИнтервалу(ДатаПриобретения, ВидТО, ДатаДокумента) Экспорт
	
	Если ДатаПриобретения = Неопределено Тогда
		ДатаПриобретения = ДатаДокумента;
	КонецЕсли;
	
	ДатаАнализа = Дата(Год(ДатаДокумента), Месяц(ДатаПриобретения), День(ДатаПриобретения));
	
	Если ВидТО = ИмяТекущееВР() Тогда
		Если ДатаДокумента > ДатаАнализа Тогда
			Возврат ДатаАнализа;
		Иначе
			Возврат Дата(Год(ДатаДокумента) - 1, Месяц(ДатаПриобретения), День(ДатаПриобретения));
		КонецЕсли;
	ИначеЕсли ВидТО = ИмяСледующееВР() Тогда
		СледующийГодДатаАнализа = ДобавитьМесяц(ДатаАнализа, 12);
		СледующийГодДатаДокумента = ДобавитьМесяц(ДатаДокумента, 12);
		Если СледующийГодДатаДокумента > СледующийГодДатаАнализа Тогда
			Возврат СледующийГодДатаАнализа;
		Иначе
			Возврат НачалоГода(СледующийГодДатаАнализа) - 1;
		КонецЕсли;
	ИначеЕсли ВидТО = ИмяПрошлогоВР() Тогда
		КонецПрошлыйГодДатаАнализа = ДобавитьМесяц(ДатаАнализа, -12);
		КонецПрошлыйГодДатаДокумента = ДобавитьМесяц(ДатаДокумента, -12);
		Если КонецПрошлыйГодДатаДокумента > КонецПрошлыйГодДатаАнализа Тогда
			Возврат КонецПрошлыйГодДатаАнализа;
		Иначе
			Возврат НачалоГода(КонецПрошлыйГодДатаАнализа) - 1;
		КонецЕсли;
	КонецЕсли;
	
	ВызватьИсключение "Not implemented";
	
КонецФункции

Функция ПробегТОПоИнтервалу(ВидТО, ТекущийНомерТО, МежсервисныйИнтервал, ТекущийПробег) Экспорт
	
	Если ВидТО = ИмяТекущееВР() Тогда
		Возврат ТекущийНомерТО * МежсервисныйИнтервал;
	ИначеЕсли ВидТО = ИмяСледующееВР() Тогда
		Возврат (ТекущийНомерТО + 1) * МежсервисныйИнтервал;
	ИначеЕсли ВидТО = ИмяПрошлогоВР() Тогда
		Возврат (ТекущийНомерТО - 1) * МежсервисныйИнтервал;
	КонецЕсли;
	
	ВызватьИсключение "Not implemented";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПеренестиЗначенияРеквизитов(СписокРеквизитов, СтрокаРаботы, ВидВРСтроки, ДатаАнализа, ВыполненныеРаботыПриведенная, Счетчик)
	
	ВидыВР = ПолучитьВидыВР();
	
	Для каждого ВидВР Из ВидыВР Цикл
		Если ТОВходитВИнтервал(ДатаАнализа, ВидВР, СтрокаРаботы[ВидВРСтроки + "Период"]) Тогда
			Если ВидВР = ВидВРСтроки Тогда
					Продолжить;
			КонецЕсли;
			Для каждого РеквизитСписка Из СписокРеквизитов Цикл
				ВыполненныеРаботыПриведенная.Получить(Счетчик)[ВидВР + РеквизитСписка] = СтрокаРаботы[ВидВРСтроки + РеквизитСписка];
				ВыполненныеРаботыПриведенная.Получить(Счетчик)[ВидВРСтроки + РеквизитСписка] = 
					ОбщегоНазначения.НезаполненноеЗначение(ВыполненныеРаботыПриведенная.Получить(Счетчик)[ВидВРСтроки + РеквизитСписка]);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла
	
КонецПроцедуры

Функция ТОВходитВИнтервал(ДатаАнализа, ВидТО, ДатаТО) Экспорт
	
	Если ВидТО = ИмяТекущееВР() Тогда
		Возврат ДатаТО >= НачалоГода(ДатаАнализа) И ДатаТО <= КонецГода(ДатаАнализа);
	ИначеЕсли ВидТО = ИмяСледующееВР() Тогда
		НачалоСледующийГод = КонецГода(ДатаАнализа) + 1;
		Возврат ДатаТО >= НачалоСледующийГод И ДатаТО <= КонецГода(НачалоСледующийГод);
	ИначеЕсли ВидТО = ИмяПрошлогоВР() Тогда
		КонецПрошлыйГод = НачалоГода(ДатаАнализа) - 1;
		Возврат ДатаТО >= НачалоГода(КонецПрошлыйГод) И ДатаТО <= КонецПрошлыйГод;
	КонецЕсли;
	
	ВызватьИсключение "Not implemented";
	
КонецФункции

Функция УзнатьВидТОПоИмениЭлемента(ИмяЭлемента) Экспорт
	
	ВидыТО = ПолучитьВидыВР();
	
	Для каждого ВидТО Из ВидыТО Цикл
		Если СтрНачинаетсяС(ИмяЭлемента, ВидТО) Тогда
			Возврат ВидТО;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти