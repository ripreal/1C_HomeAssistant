﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПрисоединитьФайлы(ПараметрыВыполненияКоманды);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрисоединитьФайлы(ПараметрыВыполненияКоманды)
	
	Данные = ПрикрепленныеФайлыКлиент.НоваяФотография(, ПараметрыВыполненияКоманды.Источник);	
	Если Данные <> Неопределено Тогда
		Оповестить(ПрикрепленныеФайлыКлиент.ИмяСобытияГенерацииМультимедиа(), Данные, ПараметрыВыполненияКоманды.Источник);
	КонецЕсли;
	
КонецПроцедуры

 