#priority 1000
#modloaded create

import crafttweaker.api.block.Block;
import crafttweaker.api.block.BlockState;
import crafttweaker.api.data.IData;
import crafttweaker.api.data.ListData;
import crafttweaker.api.data.MapData;
import crafttweaker.api.fluid.Fluid;
import crafttweaker.api.fluid.IFluidStack;
import crafttweaker.api.ingredient.IIngredientWithAmount;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.item.ItemDefinition;
import crafttweaker.api.ingredient.IIngredient;
import crafttweaker.api.resource.ResourceLocation;
import crafttweaker.api.tag.type.KnownTag;
import crafttweaker.api.world.Level;
import crafttweaker.api.util.math.BlockPos;
import crafttweaker.api.util.Many;
import crafttweaker.api.util.random.Percentaged;
import stdlib.List;

public class CreateIngredient {
    protected var data as MapData = new MapData();

    public this(type as string, data as MapData) {
        this.data = ({"type": type} as MapData).merge(data);
    }

    public this(data as MapData) {
        this.data.merge(data);
    }

    public asData() as IData => data;
    public implicit as IData => data;
}

public class CreateInputs {
    // 安装物品
    public static deploying(input as IIngredient) as CreateIngredient {
        var map as MapData = {
            results: [],
            ingredients: []
        };
        map["ingredients"].add(input as IData);
        return new CreateIngredient("create:deploying",map);
    }

    // 辊压
    public static pressing() as CreateIngredient {
        var map as MapData = {
            results: [],
            ingredients: []
        };
        return new CreateIngredient("create:pressing",map);
    }

    // 注入流体
    public static filling(fluidStack as IFluidStack) as CreateIngredient {
        var map as MapData = {
            results: [],
            ingredients: []
        };
        map["ingredients"].add(fluidIn(fluidStack).asData());
        return new CreateIngredient("create:filling",map);
    }

    // 请勿使用（该方法用于隐式转换）
    public static fluidIn(fluidStack as IFluidStack,chance as double = 1.0) as CreateIngredient {
        return new CreateIngredient({
            type: "fluid_stack",
            id: fluidStack.fluid.registryName.toString(),
            fluid: fluidStack.fluid.registryName.toString(),
            amount: fluidStack.amount,
            chance: chance
        });
    }

    // 请勿使用（该方法用于隐式转换）
    public static fluidOut(fluidStack as IFluidStack) as CreateIngredient {
        return new CreateIngredient({
            fluid: fluidStack.fluid.registryName.toString(),
            id: fluidStack.fluid.registryName.toString(),
            amount: fluidStack.amount
        });
    }

    // 请勿使用（该方法用于隐式转换）
    public static fluidTagIn(fluid as Many<KnownTag<Fluid>>,chance as double = 1.0) as CreateIngredient {
        return new CreateIngredient({
            type: "fluid_tag",
            fluid_tag: fluid.data.id(),
            amount: fluid.amount
        });
    }

    // 请勿使用（该方法用于隐式转换）
    public static itemStackWithChance(input as IItemStack, chance as double = 1.0) as CreateIngredient {
        var map as MapData = {};
        map.put("chance", chance);
        map.merge(DataConvertUtils.convertItemStack(input));
        return new CreateIngredient(map);
    }
}

public expand IItemStack {
    public asCreateIngredient() as CreateIngredient => new CreateIngredient(DataConvertUtils.convertItemStack(this));
    public implicit as CreateIngredient => new CreateIngredient(DataConvertUtils.convertItemStack(this));
}

public expand Many<KnownTag<ItemDefinition>> {
    public asCreateIngredient() as CreateIngredient => new CreateIngredient({
        tag: this.data.id,
        amount: this.amount
    });
    public implicit as CreateIngredient => new CreateIngredient({
        tag: this.data.id,
        amount: this.amount
    });
}

public expand IFluidStack {
    public asCreateIngredient() as CreateIngredient => CreateInputs.fluidIn(this);
    public implicit as CreateIngredient => CreateInputs.fluidIn(this);
}

public expand Many<KnownTag<Fluid>> {
    public asCreateIngredient() as CreateIngredient => CreateInputs.fluidTagIn(this);
    public implicit as CreateIngredient => CreateInputs.fluidTagIn(this);
}

public expand Percentaged<IItemStack> {
    public asCreateIngredient() as CreateIngredient => CreateInputs.itemStackWithChance(this.data, this.percentage);
    public implicit as CreateIngredient => CreateInputs.itemStackWithChance(this.data, this.percentage);
}

public expand Percentaged<Many<KnownTag<ItemDefinition>>> {
    public asCreateIngredient() as CreateIngredient => new CreateIngredient({
        tag: this.data.data.id,
        amount: this.data.amount,
        chance: this.percentage
    });
    public implicit as CreateIngredient => new CreateIngredient({
        tag: this.data.data.id,
        amount: this.data.amount,
        chance: this.percentage
    });
}

public expand Percentaged<IFluidStack> {
    public asCreateIngredient() as CreateIngredient => CreateInputs.fluidIn(this.data, this.percentage);
    public implicit as CreateIngredient => CreateInputs.fluidIn(this.data, this.percentage);
}

public expand Percentaged<Many<KnownTag<Fluid>>> {
    public asCreateIngredient() as CreateIngredient => CreateInputs.fluidTagIn(this.data, this.percentage);
    public implicit as CreateIngredient => CreateInputs.fluidTagIn(this.data, this.percentage);
}