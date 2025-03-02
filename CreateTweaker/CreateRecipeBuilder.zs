#priority 1000
#modloaded create

import crafttweaker.api.data.MapData;
import crafttweaker.api.data.IData;
import crafttweaker.api.data.ListData;
import crafttweaker.api.fluid.IFluidStack;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.ingredient.IIngredient;
import stdlib.List;

public class CreateRecipeBuilder {
    private var recipe as MapData;

    public this() {
        recipe = {};
    }

    public getRecipe() as MapData => recipe;

    public inputs(input as CreateIngredient[]) as CreateRecipeBuilder {
        var ingredientList as ListData = new ListData();
        for input1 in input {
            ingredientList.add(input1);
        }
        recipe.put("ingredients",ingredientList);
        return this;
    }

    public input(input as IIngredient) as CreateRecipeBuilder {
        recipe.put("ingredient",input as IData);
        return this;
    }

    public loop(loops as int) as CreateRecipeBuilder {
        recipe.put("loops",loops);
        return this;
    }

    public results(results as CreateIngredient[]) as CreateRecipeBuilder {
        var resultsList as ListData = new ListData();
        for result in results {
            resultsList.add(result);
        }
        recipe.put("results",resultsList);
        return this;
    }

    public result(result as CreateIngredient) as CreateRecipeBuilder {
        recipe.put("result",result);
        return this;
    }

    public sequence(sequences as CreateIngredient[],transitionalItem as IItemStack) as CreateRecipeBuilder {
        var sequenceList as ListData = new ListData();
        val transitionalItem as MapData = DataConvertUtils.convertItemStack(transitionalItem);
        for sequence in sequences {
            var sequenceMap as MapData = sequence.asData();
            sequenceMap["ingredients"].add(transitionalItem);
            var ingredientList as ListData = new ListData();
            ingredientList.add(transitionalItem);
            for data in sequenceMap["ingredients"] {
                ingredientList.add(data);
            }
            sequenceMap.merge({"ingredients": ingredientList});
            sequenceMap["results"].add(transitionalItem);
            sequenceList.add(sequenceMap);
        }
        recipe.put("transitional_item",transitionalItem);
        recipe.put("sequence",sequenceList);
        return this;
    }

    public sequence(sequences as CreateIngredient[]) as CreateRecipeBuilder {
        var sequenceList as ListData = new ListData();
        for sequence in sequences {
            sequenceList.add(sequence);
        }
        recipe.put("sequence",sequenceList);
        return this;
    }

    public transitionalItem(transitionalItem as IItemStack) as CreateRecipeBuilder {
        val transitionalItem as MapData = DataConvertUtils.convertItemStack(transitionalItem);
        recipe.put("transitional_item",transitionalItem);
        return this;
    }
    // heated、superheated or none
    public heatRequirement(heat as string = "") as CreateRecipeBuilder {
        if (heat in ["heated","superheated"]) recipe.put("heat_requirement",heat);
        return this;
    }

    public processingTime(time as int = 200) as CreateRecipeBuilder {
        recipe.put("processing_time",time);
        return this;
    }

    public keepHeldItem(keep as bool = true) as CreateRecipeBuilder {
        recipe.put("keep_held_item",keep);
        return this;
    }
    
    public mechanicalCraftingInput(inputs as IIngredient[][]) as CreateRecipeBuilder {
        recipe.merge(DataConvertUtils.toPatternAndKey(inputs));
        return this;
    }

    public showNotification(show as bool = true) as CreateRecipeBuilder {
        recipe.put("show_notification",show);
        return this;
    }

    public acceptMirrored(show as bool = true) as CreateRecipeBuilder {
        recipe.put("accept_mirrored",show);
        return this;
    }

    public category(show as string = "misc") as CreateRecipeBuilder {
        recipe.put("category",show);
        return this;
    }
}