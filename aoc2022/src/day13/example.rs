use crate::day13::day13a::Item;
use crate::day13::day13a::Item::{IntItem, ListItem};

pub fn read_input_example() -> Vec<Vec<Item>> {
    vec![
        vec![
            ListItem(vec![
                IntItem(1),
                IntItem(1),
                IntItem(3),
                IntItem(1),
                IntItem(1),
            ]),
            ListItem(vec![
                IntItem(1),
                IntItem(1),
                IntItem(5),
                IntItem(1),
                IntItem(1),
            ]),
        ],
        vec![
            ListItem(vec![
                ListItem(vec![IntItem(1)]),
                ListItem(vec![IntItem(2), IntItem(3), IntItem(4)]),
            ]),
            ListItem(vec![ListItem(vec![IntItem(1)]), IntItem(4)]),
        ],
        vec![
            ListItem(vec![IntItem(9)]),
            ListItem(vec![ListItem(vec![IntItem(8), IntItem(7), IntItem(6)])]),
        ],
        vec![
            ListItem(vec![
                ListItem(vec![IntItem(4), IntItem(4)]),
                IntItem(4),
                IntItem(4),
            ]),
            ListItem(vec![
                ListItem(vec![IntItem(4), IntItem(4)]),
                IntItem(4),
                IntItem(4),
                IntItem(4),
            ]),
        ],
        vec![
            ListItem(vec![IntItem(7), IntItem(7), IntItem(7), IntItem(7)]),
            ListItem(vec![IntItem(7), IntItem(7), IntItem(7)]),
        ],
        vec![ListItem(vec![]), ListItem(vec![IntItem(3)])],
        vec![
            ListItem(vec![ListItem(vec![ListItem(vec![])])]),
            ListItem(vec![ListItem(vec![])]),
        ],
        vec![
            ListItem(vec![
                IntItem(1),
                ListItem(vec![
                    IntItem(2),
                    ListItem(vec![
                        IntItem(3),
                        ListItem(vec![
                            IntItem(4),
                            ListItem(vec![IntItem(5), IntItem(6), IntItem(7)]),
                        ]),
                    ]),
                ]),
                IntItem(8),
                IntItem(9),
            ]),
            ListItem(vec![
                IntItem(1),
                ListItem(vec![
                    IntItem(2),
                    ListItem(vec![
                        IntItem(3),
                        ListItem(vec![
                            IntItem(4),
                            ListItem(vec![IntItem(5), IntItem(6), IntItem(0)]),
                        ]),
                    ]),
                ]),
                IntItem(8),
                IntItem(9),
            ]),
        ],
    ]
}
