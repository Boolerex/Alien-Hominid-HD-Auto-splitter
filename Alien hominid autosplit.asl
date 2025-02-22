state("AlienHominidHD")
{
    int secondlevelnumber: 0x38F024,0x20,0xF08; // Level number in the right, X-X< This one
    int firstlevelnumber: 0x38F024,0x20,0xF14; // Level number in the left, this one >X-X, technically the world number
    // float FinalBossHpBar: 0x38F034,0x10,0x10,0x11C,0xE8,0x258,0x568,0x1A8 // Final boss hp bar 
    float FinalBossHpBar: 0x38F01C,0x10C,0x70,0x8,0x244,0x858,0x3E8,0x1D8 // Final boss hp bar, personal note: it Hp bar fake 2
    // float FinalBossHP: 0x38F014,0x1504,0x124,0x5C,0x158;0x36C,0x48,0x708
}

startup
{
    int maxhpcount = 0;
     //settings.Add("Reset in menu");
     //settings.SetToolTip("Reset in menu","Activate reset when going back to the main menu, recommended to deactivate if you are doing all hat run or if you expect to game over");
}

init
{
    vars.maxhpcount = 0;
}

// update { print(vars.maxhpcount.ToString()); }

start
{ // If the level number is not 4-0, then we are outside the main menu and in a level
    if(current.firstlevelnumber != 4 && current.secondlevelnumber != 0){
        vars.maxhpcount = 0;
        return true;
        
    }
}       

split
{ // If the level number go up, then we are in the next level, we check world number and level, 
// and if we don't end up in the main menu, which can happen if we game over
    if(current.firstlevelnumber != 4 && current.secondlevelnumber != 0 && (current.firstlevelnumber > old.firstlevelnumber || current.secondlevelnumber > old.secondlevelnumber)){
        vars.maxhpcount = 0;
        return true;
    }
    // Special condition for the final boss
    // We use a global variable to count the number of time the boss fill up his hp bar
    // Once the boss fill his hp bar the third time, we are at the start of this third phase
    // at that point we just need to check if the boss hp bar is empty to do the final split and end the run

     if(current.firstlevelnumber == 3 && current.secondlevelnumber == 5){
        if (current.FinalBossHpBar == 1 && old.FinalBossHpBar != 1){
            vars.maxhpcount++;
        }
        if (current.FinalBossHpBar == 0 && vars.maxhpcount >= 3){
            return true;
        }
    } 
}

reset
{
    // If the level number is 4-0, then we are in the main menu
    // It possible to get back to the main menu during normal run though if we game over or during a all hat run, 
    // so it commented for now til I figure out something better
    if(current.firstlevelnumber == 4 && current.secondlevelnumber == 0){
        return true;
    }


}

isLoading
{
    
}
