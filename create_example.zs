#noload

/*
    <recipetype:create:item_application>//手动使用物品
    <recipetype:create:mixing> //混合搅拌
    <recipetype:create:compacting> //压块塑型
    <recipetype:create:conversion> //神秘转换 --- 无法使用（？
    <recipetype:create:filling> //注液
    <recipetype:create:basin> //???? --- 内置合成好像没用到
    <recipetype:create:crushing> //粉碎
    <recipetype:create:emptying> //分液
    <recipetype:create:cutting> //切割
    <recipetype:create:splashing> //批量洗涤
    <recipetype:create:deploying> //使用
    <recipetype:create:milling> //研磨
    <recipetype:create:mechanical_crafting> //动力合成
    <recipetype:create:sequenced_assembly> //序列组装
    <recipetype:create:haunting> //批量缠绕
    <recipetype:create:sandpaper_polishing> //砂纸抛光
    <recipetype:create:pressing> //金属压片
*/
CreateRecipeManager.addRecipe(<recipetype:create:sequenced_assembly>, new CreateRecipeBuilder()
    .input(<item:minecraft:glowstone_dust>)
    .loops(10)
    .results([
        <item:minecraft:glowstone>,
        <item:minecraft:glowstone_dust> % 9900
    ])
    .sequence([
        CreateInputs.pressing(),
        CreateInputs.pressing(),
        CreateInputs.pressing(),
        CreateInputs.pressing(),
        CreateInputs.pressing(),
        CreateInputs.pressing(),
        CreateInputs.pressing(),
        CreateInputs.pressing(),
        CreateInputs.pressing(),
        CreateInputs.pressing(),
        CreateInputs.filling(<fluid:minecraft:water> * 1000),
    ],<item:minecraft:glowstone_dust>)
);

CreateRecipeManager.addRecipe(<recipetype:create:item_application>, new CreateRecipeBuilder()
    .inputs([<item:minecraft:glowstone>,<item:create:polished_rose_quartz>])
    .results([<item:create:brass_casing>])
);

CreateRecipeManager.addRecipe(<recipetype:create:mixing>, new CreateRecipeBuilder()
    .heatRequirement()
    .inputs([<item:minecraft:iron_nugget>,<fluid:minecraft:water> * 1000])
    .results([<item:create:polished_rose_quartz>])
);

CreateRecipeManager.addRecipe(<recipetype:create:compacting>, new CreateRecipeBuilder()
    .inputs([<item:create:polished_rose_quartz>,<item:create:polished_rose_quartz>,<item:create:polished_rose_quartz>,<item:create:polished_rose_quartz>,<item:create:polished_rose_quartz>,<item:create:polished_rose_quartz>])
    .results([<item:minecraft:grass_block>])
);

CreateRecipeManager.addRecipe(<recipetype:create:conversion>, new CreateRecipeBuilder()
    .inputs([<item:create:polished_rose_quartz>])
    .results([<item:minecraft:grass_block>])
);

CreateRecipeManager.addRecipe(<recipetype:create:filling>, new CreateRecipeBuilder()
    .inputs([<item:create:polished_rose_quartz>, <fluid:minecraft:water> * 1000])
    .results([<item:minecraft:grass_block>])
);

CreateRecipeManager.addRecipe(<recipetype:create:crushing>, new CreateRecipeBuilder()
    .inputs([<item:minecraft:coal> * 64])
    .processingTime(400)
    .results([<item:create:shaft>])
);

CreateRecipeManager.addRecipe(<recipetype:create:emptying>, new CreateRecipeBuilder()
    .inputs([<item:create:polished_rose_quartz>])
    .results([<fluid:minecraft:water> * 1000,<item:create:shaft>])
);

CreateRecipeManager.addRecipe(<recipetype:create:cutting>, new CreateRecipeBuilder()
    .inputs([<item:create:polished_rose_quartz>])
    .results([<fluid:minecraft:water> * 1000,<item:create:shaft>])
);

CreateRecipeManager.addRecipe(<recipetype:create:cutting>, new CreateRecipeBuilder()
    .inputs([<item:minecraft:bricks>])
    .processingTime(400)
    .results([<item:minecraft:brick>])
);

CreateRecipeManager.addRecipe(<recipetype:create:splashing>, new CreateRecipeBuilder()
    .inputs([<item:minecraft:flint>])
    .processingTime(400)
    .results([<item:minecraft:netherite_scrap> % 25])
);

CreateRecipeManager.addRecipe(<recipetype:create:mechanical_crafting>, new CreateRecipeBuilder()
    .inputs(
        [
            [<item:minecraft:air>,<item:minecraft:grass_block>,<item:minecraft:grass_block>,<item:minecraft:grass_block>,<item:minecraft:air>],
            [<item:minecraft:grass_block>,<item:minecraft:grass_block>,<item:minecraft:grass_block>,<item:minecraft:grass_block>,<item:minecraft:grass_block>],
            [<item:minecraft:air>,<item:minecraft:grass_block>,<item:minecraft:grass_block>,<item:minecraft:grass_block>,<item:minecraft:air>]
        ]
    )
    .acceptMirrored(true)
    .result(<item:minecraft:netherite_scrap>)
);