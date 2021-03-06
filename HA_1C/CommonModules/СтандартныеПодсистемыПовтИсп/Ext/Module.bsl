﻿
////////////////////////////////////////////////////////////////////////////////
// Сокращенная версия одноименного модуля "Библиотеки стандартных подсистем"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Получает ссылку предопределенного элемента по его полному имени.
//  Подробнее - см. ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент();
//
Функция ПредопределенныйЭлемент(Знач ПолноеИмяПредопределенного) Экспорт
	
	ИмяПредопределенного = ВРег(ПолноеИмяПредопределенного);
	
	Точка = СтрНайти(ИмяПредопределенного, ".");
	ИмяКоллекции = Лев(ИмяПредопределенного, Точка - 1);
	ИмяПредопределенного = Сред(ИмяПредопределенного, Точка + 1);
	
	Точка = СтрНайти(ИмяПредопределенного, ".");
	ИмяТаблицы = Лев(ИмяПредопределенного, Точка - 1);
	ИмяПредопределенного = Сред(ИмяПредопределенного, Точка + 1);
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1 Ссылка ИЗ &ПолноеИмяТаблицы ГДЕ ИмяПредопределенныхДанных = &ИмяПредопределенного";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолноеИмяТаблицы", ИмяКоллекции + "." + ИмяТаблицы);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ИмяПредопределенного", ИмяПредопределенного);

	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Возврат Результат.Выгрузить()[0].Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции
