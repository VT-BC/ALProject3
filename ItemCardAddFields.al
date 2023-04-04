pageextension 50101 ItemCardAddFields extends "Item Card"
{
    layout
    {

        addfirst(InventoryGrp)
        {
            field("WebShop Tag"; Rec."WebShop Tag")
            {
                ApplicationArea = All;
            }
        }
    }

}