package soulsoft_formats_asn1

private let DefaultTwoDigitMax = 2049

public struct AsnReaderOptions {
    private var _twoDigitYearMax = 0
    private var _skipSetSortOrderVerification = false

    public mut prop utcTimeTwoDigitYearMax: Int64 {
        get() {
            if (_twoDigitYearMax == 0) {
                return DefaultTwoDigitMax
            }
            return _twoDigitYearMax
        }
        set(value) {
            if (value < 1 || value > 9999) {
                throw IllegalArgumentException()
            }

            _twoDigitYearMax = value
        }
    }

    public mut prop skipSetSortOrderVerification: Bool {
        get() {
            _skipSetSortOrderVerification
        }
        set(value) {
            _skipSetSortOrderVerification = value
        }
    }
}
