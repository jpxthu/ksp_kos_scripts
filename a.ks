// local msg to V(0, 0, 0).

// until False {
//     local sth is False.
//     until Core:Messages:Empty {
//         set msg to Core:Messages:Pop.
//         set sth to True.
//     }
//     if sth {
//         print msg:Content.
//     }
//     wait 0.1.
// }

set impPos to Ship:Position.
function GetImpPos {
    local sth is False.
    until Core:Messages:Empty {
        set msg to Core:Messages:Pop.
    }
    if sth {
        set impPos to msg:Content.
    }
    return impPos.
}

set tmp to GetImpPos().
