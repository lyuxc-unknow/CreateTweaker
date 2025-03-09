#priority 1001
#modloaded create

import crafttweaker.api.data.IData;
import crafttweaker.api.data.MapData;
import crafttweaker.api.fluid.IFluidStack;
import crafttweaker.api.ingredient.IIngredient;

public class CreateInputs {
    // deploy item
    // 安装物品
    public static deploying(input as IIngredient) as CreateIngredient {
        var map as MapData = {
            results: [],
            ingredients: []
        };
        map["ingredients"].add(input as IData);
        return new CreateIngredient("create:deploying",map);
    }

    // pressing
    // 辊压
    public static pressing() as CreateIngredient {
        var map as MapData = {
            results: [],
            ingredients: []
        };
        return new CreateIngredient("create:pressing",map);
    }

    // filling fluid
    // 注入流体
    public static filling(fluidStack as IFluidStack) as CreateIngredient {
        var map as MapData = {
            results: [],
            ingredients: []
        };
        map["ingredients"].add(AutomaticConversion.fluidIn(fluidStack).asData());
        return new CreateIngredient("create:filling",map);
    }
}