# std.io – wejście/wyjście

Moduł `std.io` dostarcza prymitywów do pracy ze strumieniami
wejścia/wyjścia. Obejmuje on uchwyty do standardowych strumieni,
uogólnione interfejsy `Reader` i `Writer`, mechanizmy buforowania oraz
narzędzia do pracy z danymi w pamięci. Znajomość tych elementów pozwala
na budowanie efektywnych i przenośnych programów konsolowych.

## Uruchomienie przykładu

```sh
zig run main.zig
```

## Standardowe strumienie

Zig udostępnia trzy podstawowe strumienie:

- `std.io.getStdIn()` – wejście standardowe
- `std.io.getStdOut()` – wyjście standardowe
- `std.io.getStdErr()` – strumień błędów

Każdy z nich zwraca strukturę zawierającą metody `reader()` lub
`writer()` pozwalające pobrać odpowiedni interfejs.

```zig
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

try stdout.print("Wpisz tekst i zakończ Enterem: ", .{});
var buf: [100]u8 = undefined;
const line = try stdin.readUntilDelimiterOrEof(&buf, '\n');
try stdout.print("Otrzymano: {s}\n", .{line});
```

## Czytniki i pisarze

`Reader` i `Writer` to generyczne interfejsy opisujące operacje odczytu
oraz zapisu. Wiele typów – pliki, gniazda sieciowe, strumienie w
pamięci – implementuje te interfejsy, dzięki czemu kod może być
ponownie użyty z różnymi źródłami danych.

Najważniejsze metody:

- `read` – odczyt określonej liczby bajtów do bufora
- `readAll` – próbuje wypełnić cały bufor (zwraca błąd przy końcu
  strumienia)
- `readUntilDelimiterOrEof` – odczyt do napotkania znaku lub końca
- `write`/`writeAll` – zapis danych
- `print` – formatowany zapis podobny do `printf`

## Buforowanie

Bezpośrednie operacje na strumieniach mogą wiązać się z częstymi
wywołaniami systemowymi. Aby je ograniczyć, warto używać
`bufferedReader` i `bufferedWriter`.

```zig
var stdin_file = std.io.getStdIn();
var stdout_file = std.io.getStdOut();

var br = std.io.bufferedReader(stdin_file.reader());
var bw = std.io.bufferedWriter(stdout_file.writer());
const reader = br.reader();
var writer = bw.writer();

try writer.print("Podaj imię: ", .{});
try bw.flush();
var name_buf: [32]u8 = undefined;
const name = try reader.readUntilDelimiterOrEof(&name_buf, '\n');
try writer.print("Witaj, {s}!\n", .{name});
try bw.flush();
```

> **Porada:** pamiętaj o `flush()` – bez tego dane pozostaną w buforze i
> nie pojawią się na ekranie.

## Strumienie w pamięci

Gdy potrzebny jest strumień działający na tablicy bajtów w pamięci,
użyj `std.io.fixedBufferStream`.

```zig
var storage: [64]u8 = undefined;
var fbs = std.io.fixedBufferStream(&storage);
const w = fbs.writer();
try w.print("liczba={d}", .{42});
const written = fbs.getWritten();
// written zawiera zapisany ciąg "liczba=42"
```

Istnieje również `std.io.BufferAllocatorStream`, który dynamicznie
powiększa bufor przy użyciu przydzielacza.

## Null stream

`std.io.nullWriter` oraz `std.io.nullReader` pozwalają odrzucać dane lub
zastępować brakujące źródła/cele wejścia i wyjścia.

```zig
const sink = std.io.nullWriter;
try sink.print("To się nie pojawi nigdzie\n", .{});
```

## Dobre praktyki

- Każda operacja I/O może zwrócić błąd – propaguj je przy użyciu `?`
  lub obsłuż.
- Reużywaj buforów, aby unikać dynamicznych alokacji.
- Funkcja `std.io.isatty` pozwala sprawdzić, czy strumień jest terminalem
  (przydatne do warunkowego formatowania).
- Strumienie są domyślnie blokujące; w przypadku potrzeby operacji
  asynchronicznych skorzystaj z `async` oraz `std.io.poll`.

`std.io` stanowi podstawę wielu innych części biblioteki – zrozumienie
jego mechanizmów ułatwi pracę z plikami, siecią i formatowaniem danych.

