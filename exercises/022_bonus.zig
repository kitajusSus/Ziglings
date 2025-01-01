// chce zrobic kod który pokazuje wam jak wyglada dokladnie to scalanie bledu lub wartosci w realnym programie i samemu chciałbym to lepiej zrozumiec wiec składnia zostanie jako tako zachowana jak w oryginale i nazwy funkcji

const std = @import("std");

// Definicja zbioru błędów
const MyNumberError = error{TooSmall};

// Funkcja bonus1, która sprawdza czy liczba jest większa od 10
fn bonus1() !u16 {
    const my_number: u16 = 5;

    if (my_number <= 10) {
        return MyNumberError.TooSmall;
    }
    return my_number; // Zwracanie tylko wartości typu u16
}

pub fn main() void {
    // Wywołanie funkcji bonus1 i przypisanie wyniku do funkcja1
    const funkcja1 = bonus1();

    // Obsługa wyniku funkcji bonus1
    if (funkcja1) |number| {
        // Jeśli funkcja zwróciła wartość typu u16
        std.debug.print("Liczba jest wystarczająco duża: {}\n", .{number});
    } else |err| {
        // Jeśli funkcja zwróciła błąd
        if (err == MyNumberError.TooSmall) {
            std.debug.print("Błąd: Liczba jest za mała.\n", .{});
        }
    }
}

// chciałem pokazac ze potrafię samodzielnie napisac kod uzywajac jeddynie notatek z poprzeddnich zadan ale niestety musiałem zejrzec na reddit. obecnie uznaje ze całkiem fajnie sie uzywa tego zig i polecam.
//
//
