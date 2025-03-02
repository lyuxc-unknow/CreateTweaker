#priority 1000
import crafttweaker.api.block.Block;
import crafttweaker.api.block.BlockState;
import crafttweaker.api.data.IData;
import crafttweaker.api.data.ListData;
import crafttweaker.api.data.MapData;
import crafttweaker.api.ingredient.IIngredientWithAmount;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.item.ItemDefinition;
import crafttweaker.api.ingredient.IIngredient;
import crafttweaker.api.resource.ResourceLocation;
import crafttweaker.api.tag.type.KnownTag;
import crafttweaker.api.world.Level;
import crafttweaker.api.util.math.BlockPos;
import crafttweaker.api.util.Many;
import stdlib.List;
import uuid.UUID;

public class DataConvertUtils {
    private static val usedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#@".toAsciiBytes();

    public static convertItemStack(itemstack as IItemStack) as MapData {
        val itemData as MapData = new MapData();
        itemData.put("id",itemstack.registryName);
        itemData.put("item",itemstack.registryName);

        if (itemstack is IIngredientWithAmount) {
            itemData.put("count",(itemstack as IIngredientWithAmount).amount);
            itemData.put("amount",(itemstack as IIngredientWithAmount).amount);
        }

        val datacomponent = itemstack.components;
        val datas = new MapData();
        for component in datacomponent.list {
            val resourceId = component.registryName.toString();
            val value = component.asIData();
            if (resourceId == "minecraft:lore" && value.asList().isEmpty) continue;
            if (resourceId == "minecraft:max_stack_size" && value.asInt() in [1,2,4,8,16,32,64]) continue;
            if (resourceId == "minecraft:attribute_modifiers" && value.asString() == "{modifiers: []}") continue;
            if (resourceId == "minecraft:enchantments" && value.asString() == "{levels: {}}") continue;
            if (resourceId == "minecraft:repair_cost" && value.asInt() == 0) continue;
            if (resourceId == "minecraft:rarity" && value.asString() in ["\"common\"","\"uncommon\"","\"rare\"","\"epic\""]) continue;
            datas.put(resourceId,value);
        }

        if (!datas.isEmpty()) {
            itemData.put("components",datas);
        }

        return itemData;
    }

    public static convertTag(tag as Many<KnownTag<ItemDefinition>>) as MapData {
        val itemData as MapData = new MapData();
        itemData.put("id",tag.data.id);
        itemData.put("tag",tag.data.id);
        itemData.put("count",tag.amount);
        itemData.put("amount",tag.amount);

        return itemData;
    }

    public static toPatternAndKey(ingredients as IIngredient[][]) as MapData {
        return {
            "pattern": toPattern(ingredients),
            "key": toKey(ingredients)
        };
    }

    public static toPattern(ingredients as IIngredient[][]) as ListData {
        val pattern = new ListData(); // 最终的 pattern 数组
        val ingredientList = new List<IIngredient>(); // 存储唯一的 IIngredient
        val charList = new List<string>(); // 存储对应的字符
        var charIndex as int = 0;

        for row in ingredients {
            var rowString = "";
            for ingredient in row {
                if (ingredient.isEmpty()) {
                    rowString += " ";
                } else {
                    var index as int = ingredientList.indexOf(ingredient) as uint;
                    if (index == -1) {
                        ingredientList.add(ingredient);
                        charList.add(usedChars[charIndex] as char);
                        index = ingredientList.length as uint - 1;
                        charIndex += 1;
                    }
                    rowString += charList[index];
                }
            }
            pattern.add(rowString);
        }

        return pattern;
    }

    public static toKey(ingredients as IIngredient[][]) as MapData {
        val ingredientList = new List<IIngredient>();
        val charList = new List<string>();
        var charIndex as int = 0;
    
        // 遍历所有 ingredient，记录每个非空 ingredient 及其对应的字符
        for row in ingredients {
            for ingredient in row {
                if (!ingredient.isEmpty()) {
                    var index as int = ingredientList.indexOf(ingredient) as uint;
                    if (index == -1) {
                        ingredientList.add(ingredient);
                        charList.add(usedChars[charIndex] as char);
                        charIndex = charIndex + 1;
                    }
                }
            }
        }
    
        // 构造 key 映射的 MapData
        val keyMap = new MapData();
        var i as int = 0;
        while(i < ingredientList.length as int) {
            keyMap.put(charList[i as uint] as string, ingredientList[i as uint] as IData);
            i = i + 1;
        }
        return keyMap;
    }

    public static recipesName() as string {
        return UUID.random() as string;
    }
}