﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.ЗарегистрированныеТО.Записывать = Истина;
	Для Каждого ТекСтрокаВыполненныеРаботы Из ВыполненныеРаботы Цикл
		Движение = Движения.ЗарегистрированныеТО.Добавить();
		Движение.Период = ТекСтрокаВыполненныеРаботы.ДатаВыполнения;
		Движение.Автомобиль = Автомобиль;
		Движение.РегламентнаяРабота = ТекСтрокаВыполненныеРаботы.РегламентнаяРабота;
		Движение.СтатусТО = Перечисления.СтатусыВыполненияТО.Пройдено;
	КонецЦикла;
	
КонецПроцедуры
