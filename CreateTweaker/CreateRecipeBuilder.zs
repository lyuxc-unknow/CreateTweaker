#priority 1000
#modloaded create

import crafttweaker.api.data.MapData;
import crafttweaker.api.data.IData;
import crafttweaker.api.data.ListData;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.ingredient.IIngredient;

public class CreateRecipeBuilder {
    private var recipe as MapData;

    public this() {
        recipe = {};
    }

    public getRecipe() as MapData => recipe;

    // Input (multiple type)
    // 输入（多种）
    public inputs(input as CreateIngredient[]) as CreateRecipeBuilder {
        var ingredientList as ListData = new ListData();
        for input1 in input {
            ingredientList.add(input1);
        }
        recipe.put("ingredients",ingredientList);
        return this;
    }

    // Input (single type)
    // 输入（单种）
    public input(input as IIngredient) as CreateRecipeBuilder {
        recipe.put("ingredient",input as IData);
        return this;
    }
    
    // Output (multiple type)
    public results(results as CreateIngredient[]) as CreateRecipeBuilder {
        var resultsList as ListData = new ListData();
        for result in results {
            resultsList.add(result);
        }
        recipe.put("results",resultsList);
        return this;
    }

    // Output (single type)
    // Maybe it is only used for sequence assembly
    // 单种输出
    // 也许只有序列组装才接受result参数
    public result(result as CreateIngredient) as CreateRecipeBuilder {
        recipe.put("result",result);
        return this;
    }
    
    // Sequence assembly loop times
    // 序列组装循环次数
    public loops(loopTimes as int) as CreateRecipeBuilder {
        recipe.put("loops",loopTimes);
        return this;
    }

    // Mechanical Crafting: Items needed for crafting
    // 动力合成合成所需物品
    public inputs(inputs as IIngredient[][]) as CreateRecipeBuilder {
        recipe.merge(DataConvertUtils.toPatternAndKey(inputs));
        return this;
    }

    // Sequence assembly steps
    // 序列组装步骤
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

    // // Display notification (mechanical crafting)
    // 显示通知（动力合成）
    public showNotification(show as bool = true) as CreateRecipeBuilder {
        recipe.put("show_notification",show);
        return this;
    }

    // Accept mirror to crafting (mechanical crafting) (required)
    // 允许镜像合成（动力合成）
    public acceptMirrored(show as bool = true) as CreateRecipeBuilder {
        recipe.put("accept_mirrored",show);
        return this;
    }

    // Category (mechanical crafting)
    // 类别（动力合成）
    public category(show as string = "misc") as CreateRecipeBuilder {
        recipe.put("category",show);
        return this;
    }

    // 请勿使用sequence(CreateIngredient[])
    // 请使用sequence(CreateIngredient[], IItemStack)
    // public sequence(sequences as CreateIngredient[]) as CreateRecipeBuilder {
    //     var sequenceList as ListData = new ListData();
    //     for sequence in sequences {
    //         sequenceList.add(sequence);
    //     }
    //     recipe.put("sequence",sequenceList);
    //     return this;
    // }

    // // 请勿使用transitionalItem(IItemStack)
    // // 请使用sequence(CreateIngredient[], IItemStack)
    // public transitionalItem(transitionalItem as IItemStack) as CreateRecipeBuilder {
    //     val transitionalItem as MapData = DataConvertUtils.convertItemStack(transitionalItem);
    //     recipe.put("transitional_item",transitionalItem);
    //     return this;
    // }

    // Whether Mixin Crafting requires heat
    // You can enter heated, superheated or none. The default is none
    // 混合合成是否需要热量
    // 可以输入 heated、superheated or none
    public heatRequirement(heat as string = "none") as CreateRecipeBuilder {
        if (heat in ["heated","superheated"]) recipe.put("heat_requirement",heat);
        return this;
    }

    // The time required for the process
    // 合成所需要的时间
    public processingTime(time as int = 200) as CreateRecipeBuilder {
        recipe.put("processing_time",time);
        return this;
    }

    // Keep the item in hand. This method is only used when <recipetype:create:deploying>
    // 保持手上的物品，仅在<recipetype:create:deploying>类型使用到
    public keepHeldItem(keep as bool = true) as CreateRecipeBuilder {
        recipe.put("keep_held_item",keep);
        return this;
    }
}