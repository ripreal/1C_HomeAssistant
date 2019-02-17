﻿
////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы с формами
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Процедура НачатьВводДаты(Форма, Элемент, Дата, Каллбек = Неопределено) Экспорт
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Оповещение = Новый ОписаниеОповещения("ЗавершитьВводДаты", 
		ФормыОбщиеДействияКлиент.ЭтотОбъект, 
		Новый Структура("Форма,ИмяЭлемента,Каллбек", Форма, Элемент.Имя, Каллбек)
	);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВводаДаты", 
		Новый Структура("Дата", Дата), 
		Элемент,,,, 
		Оповещение, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);
	
КонецПроцедуры

Процедура ЗавершитьВводДаты(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Попытка
		Форма[ДополнительныеПараметры.ИмяЭлемента] = РезультатЗакрытия;
	Исключение
		Объект[ДополнительныеПараметры.ИмяЭлемента] = РезультатЗакрытия;
	КонецПопытки;
	
	Если ДополнительныеПараметры.Каллбек <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.Каллбек, РезультатЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти