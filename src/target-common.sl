;;; Parameter passing
: vars1
    [A] >t
: vars2
    [A] >t [B] >t
: vars3
    [A] >t [B] >t [C] >t
: vars4
    [A] >t [B] >t [C] >t [D] >t
: vars5
    [A] >t [B] >t [C] >t [D] >t [E] >t
: vars6
    [A] >t [B] >t [C] >t [D] >t [E] >t [F] >t
: return1
    t> {A}
: return2
    t> {B} t> {A}
: return3
    t> {C} t> {B} t> {A}
: return4
    t> {D} t> {C} t> {B} t> {A}
: return5
    t> {E} t> {D} t> {C} t> {B} t> {A}
: return6
    t> {F} t> {E} t> {D} t> {C} t> {B} t> {A}
