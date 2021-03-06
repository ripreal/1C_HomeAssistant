﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Дата") Тогда
		Дата = Параметры.Дата;
	КонецЕсли;
	ФормыОбщиеДействияКлиентСервер.ФорматДатыПроизвольнойФормы(ЭтотОбъект, Элементы.Дата.Имя);
	Элементы.Дата.ФорматРедактирования = "ДФ=dd/MM/yyyy";
КонецПроцедуры

&НаКлиенте
Процедура ДатаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура Принять(Команда)
	ОповеститьОВыборе(Дата);
КонецПроцедуры
