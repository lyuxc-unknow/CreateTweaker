#priority 1000
#modloaded create

import crafttweaker.api.recipe.IRecipeManager;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.ingredient.IIngredient;
import crafttweaker.api.data.IData;
import crafttweaker.api.data.ListData;
import crafttweaker.api.data.MapData;
import crafttweaker.api.util.random.Percentaged;
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
        recipes.addJsonRecipe(DataConvertUtils.recipesName(), map);
        // recipeType.addJsonRecipe(DataConvertUtils.recipesName(), builder.getRecipe());
    }
}