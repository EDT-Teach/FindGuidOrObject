﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьУИД(Команда)
	
	Объект.УИД = ПолучитьУИДНаСервере(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСсылку(Команда)
	
	Объект.Ссылка = ПолучитьСсылкуНаСервере(Объект.УИД);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьСсылкуНаСервере(ИД,Тип = Неопределено)
	
	Если ИД = "" и Тип <> Неопределено Тогда
		// Тип известен, элемент явно пустой, значит нужно вернуть пустую ссылку
		спр = Метаданные.Справочники.Найти(Тип);
		Если спр <> Неопределено Тогда
			Возврат Справочники[Тип].ПустаяСсылка();
		КонецЕсли;
		
		док = Метаданные.Документы.Найти(Тип);
		Если док <> Неопределено Тогда
			Возврат Документы[Тип].ПустаяСсылка();
		КонецЕсли;
		Возврат Неопределено
	КонецЕсли;
	
	Попытка
		УИД = Новый УникальныйИдентификатор(ИД);
	Исключение
		Возврат Неопределено
	КонецПопытки;
	
	// Если тип известен, то ищем только в одной таблице
	Если Тип <> Неопределено Тогда
		спр = Метаданные.Справочники.Найти(Тип);
		Если спр <> Неопределено Тогда
			Ссылка = Справочники[Тип].ПолучитьСсылку(УИД);
			Если Не Ссылка.Пустая() и Ссылка.ПолучитьОбъект() <> Неопределено Тогда
				Возврат Ссылка
			КонецЕсли;
			Возврат Неопределено
		КонецЕсли;
		
		док = Метаданные.Документы.Найти(Тип);
		Если док <> Неопределено Тогда
			Ссылка = Документы[Тип].ПолучитьСсылку(УИД);
			Если Не Ссылка.Пустая() и Ссылка.ПолучитьОбъект() <> Неопределено Тогда
				Возврат Ссылка
			КонецЕсли;
		КонецЕсли;
		Возврат Неопределено
	КонецЕсли;
	
	// Если тип неизвестен, то перебираем все справочники и документы.
	// Это долго. Поэтому тип очень хочется получить.
	Для Каждого спр из Метаданные.Справочники Цикл
		Ссылка = Справочники[спр.Имя].ПолучитьСсылку(УИД);
		Если Ссылка.ПолучитьОбъект() <> Неопределено Тогда
			Возврат Ссылка
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого док из Метаданные.Документы Цикл
		Ссылка = Документы[док.Имя].ПолучитьСсылку(УИД);
		Если Ссылка.ПолучитьОбъект() <> Неопределено Тогда
			Возврат Ссылка
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьУИДНаСервере(Ссылка)
	
	Возврат XMLСтрока(Ссылка);
	
КонецФункции

#КонецОбласти 
