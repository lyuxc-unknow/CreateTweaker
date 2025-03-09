#priority 1001
#modloaded create

import crafttweaker.api.data.IData;
import crafttweaker.api.data.MapData;
import crafttweaker.api.fluid.Fluid;
import crafttweaker.api.fluid.IFluidStack;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.item.ItemDefinition;
import crafttweaker.api.tag.type.KnownTag;
import crafttweaker.api.util.Many;
import crafttweaker.api.util.random.Percentaged;

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

// Do not use any methods in this class
// 请勿使用该类中的任何方法
public class AutomaticConversion {
    public static fluidIn(fluidStack as IFluidStack,chance as double = 1.0) as CreateIngredient {
        return new CreateIngredient({
            type: "fluid_stack",
            id: fluidStack.fluid.registryName.toString(),
            fluid: fluidStack.fluid.registryName.toString(),
            amount: fluidStack.amount,
            chance: chance
        });
    }

    public static fluidOut(fluidStack as IFluidStack) as CreateIngredient {
        return new CreateIngredient({
            fluid: fluidStack.fluid.registryName.toString(),
            id: fluidStack.fluid.registryName.toString(),
            amount: fluidStack.amount
        });
    }

    public static fluidTagIn(fluid as Many<KnownTag<Fluid>>,chance as double = 1.0) as CreateIngredient {
        return new CreateIngredient({
            type: "fluid_tag",
            fluid_tag: fluid.data.id(),
            amount: fluid.amount
        });
    }

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
    public asCreateIngredient() as CreateIngredient => AutomaticConversion.fluidIn(this);
    public implicit as CreateIngredient => AutomaticConversion.fluidIn(this);
}

public expand Many<KnownTag<Fluid>> {
    public asCreateIngredient() as CreateIngredient => AutomaticConversion.fluidTagIn(this);
    public implicit as CreateIngredient => AutomaticConversion.fluidTagIn(this);
}

public expand Percentaged<IItemStack> {
    public asCreateIngredient() as CreateIngredient => AutomaticConversion.itemStackWithChance(this.data, this.percentage);
    public implicit as CreateIngredient => AutomaticConversion.itemStackWithChance(this.data, this.percentage);
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
    public asCreateIngredient() as CreateIngredient => AutomaticConversion.fluidIn(this.data, this.percentage);
    public implicit as CreateIngredient => AutomaticConversion.fluidIn(this.data, this.percentage);
}

public expand Percentaged<Many<KnownTag<Fluid>>> {
    public asCreateIngredient() as CreateIngredient => AutomaticConversion.fluidTagIn(this.data, this.percentage);
    public implicit as CreateIngredient => AutomaticConversion.fluidTagIn(this.data, this.percentage);
}