#priority 1000
#modloaded create

import crafttweaker.api.recipe.IRecipeManager;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.data.MapData;
import crafttweaker.api.recipe.type.Recipe;
import crafttweaker.api.world.Container;

public class CreateRecipeManager {
    public static addRecipe(recipeType as IRecipeManager<Recipe<Container>>, builder as CreateRecipeBuilder,extendedMap as MapData = {}) as void {
        var map = builder.getRecipe();
        var temp = recipeType.commandString.split(':');
        var types  = temp[1] + ":" + temp[2].split('>')[0];
        map.merge({
            type: types
        });
        if (!extendedMap.isEmpty()) map.merge(extendedMap);
        // println(map.getAsString());
        recipes.addJsonRecipe(DataConvertUtils.recipesName(), map);
        // Create requires "type" to be so, I know this code is very bad, but I don't know how to simplify it
        // 机械动力强制要type这个类型，但是我不知道怎么去简化这坨代码，如果可以简化的话就可以直接使用下面这行了
        // recipeType.addJsonRecipe(DataConvertUtils.recipesName(), map);
    }
}