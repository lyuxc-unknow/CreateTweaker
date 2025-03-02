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

public expand IIngredient {
    public asCreateIngredient() as CreateIngredient => new CreateIngredient(this as IData);
    public implicit as CreateIngredient => new CreateIngredient(this as IData);
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
    public asLycheeFluidk() as CreateIngredient => CreateInputs.fluidIn(this);
    public implicit as CreateIngredient => CreateInputs.fluidIn(this);
}

public expand Many<KnownTag<Fluid>> {
    public asLycheeFluidk() as CreateIngredient => CreateInputs.fluidTagIn(this);
    public implicit as CreateIngredient => CreateInputs.fluidTagIn(this);
}

public class CreateInputs {
    public static deploying(input as IIngredient) as CreateIngredient {
        var map as MapData = {
            results: [],
            ingredients: []
        };
        map["ingredients"].add(input as IData);
        return new CreateIngredient("create:deploying",map);
    }

    public static pressing() as CreateIngredient {
        var map as MapData = {
            results: [],
            ingredients: []
        };
        return new CreateIngredient("create:pressing",map);
    }

    public static filling(fluidStack as IFluidStack) as CreateIngredient {
        var map as MapData = {
            results: [],
            ingredients: []
        };
        map["ingredients"].add(fluidIn(fluidStack).asData());
        return new CreateIngredient("create:filling",map);
    }

    public static fluidIn(fluidStack as IFluidStack) as CreateIngredient {
        return new CreateIngredient({
            type: "fluid_stack",
            id: fluidStack.fluid.registryName.toString(),
            fluid: fluidStack.fluid.registryName.toString(),
            amount: fluidStack.amount
        });
    }

    public static fluidOut(fluidStack as IFluidStack) as CreateIngredient {
        return new CreateIngredient({
            fluid: fluidStack.fluid.registryName.toString(),
            id: fluidStack.fluid.registryName.toString(),
            amount: fluidStack.amount
        });
    }

    public static fluidTagIn(fluid as Many<KnownTag<Fluid>>) as CreateIngredient {
        return new CreateIngredient({
            type: "fluid_tag",
            fluid_tag: fluid.data.id(),
            amount: fluid.amount
        });
    }

    public static ingredientWithChance(input as IItemStack, chance as double = 1.0) as CreateIngredient {
        var map as MapData = {};
        map.put("chance", chance);
        map.merge(DataConvertUtils.convertItemStack(input));
        return new CreateIngredient(map);
    }
}