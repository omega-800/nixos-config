/* See LICENSE file for copyright and license details. */

/* appearance */
static unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int gappx     = 5;        /* gaps between windows */
static unsigned int snap      = 32;       /* snap pixel */
static int showbar            = 1;        /* 0 means no standard bar */
static int topbar             = 1;        /* 0 means standard bar at bottom */
static const double activeopacity   = 0.9f;     /* Window opacity when it's focused (0 <= opacity <= 1) */
static const double inactiveopacity = 0.7f;     /* Window opacity when it's inactive (0 <= opacity <= 1) */
static const int extrabar           = 1;        /* 0 means no extra bar */
static const char statussep         = ';';      /* separator between statuses */

static char font[]            = "monospace:size=10";
static char dmenufont[]       = "monospace:size=10";
static const char *fonts[]          = { font };

static char normbgcolor[]       = "#222222";
static char normbordercolor[]       = "#444444";
static char normfgcolor[]       = "#bbbbbb";
static char selfgcolor[]       = "#eeeeee";
static char selbgcolor[]       = "#eeeeee";
static char selbordercolor[]        = "#005577";
static char warnfggcolor[]       = "#000000";
static char urgbgcolor[]         = "#ff0000";
static char warnbggcolor[]      = "#ffff00";
static char urgfggcolor[]       = "#ffffff";

static char *colors[][3]      = {
	/*					fg         bg          border   */
	[SchemeNorm] =	 { normfgcolor, normbgcolor,  normbordercolor },
	[SchemeSel]  =	 { selfgcolor, selbgcolor,   selbordercolor },
	[SchemeWarn] =	 { warnfggcolor, warnbggcolor, urgbgcolor },
	[SchemeUrgent]=	 { urgfggcolor, urgbgcolor,    urgbgcolor },
	[SchemeTabInactive] =	 { normfgcolor,  normbgcolor, normbordercolor },
	[SchemeTabActive]  =	 { selbgcolor, selbordercolor, selfgcolor },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   focusopacity    unfocusopacity     monitor */
{ NULL,       NULL,       NULL,       0,            0,           1,              1,                 -1 },
//	{ "st",       NULL,       NULL,       0,            0,           0.9,              0.7,                 -1 },
};

/* window following */
#define WFACTIVE '>'
#define WFINACTIVE 'v'
#define WFDEFAULT WFINACTIVE

/* layout(s) */
static float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static int nmaster     = 1;    /* number of clients in master area */
static int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int nviews      = 0;    /* mask of tags highlighted by default (tags 1-4) */
static const int statusall   = 1;    /* 1 means status is shown in all bars, not just active monitor */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

/* Bartabgroups properties */
#define BARTAB_BORDERS 1       // 0 = off, 1 = on
#define BARTAB_BOTTOMBORDER 1  // 0 = off, 1 = on
#define BARTAB_TAGSINDICATOR 1 // 0 = off, 1 = on if >1 client/view tag, 2 = always on
#define BARTAB_TAGSPX 5        // # pixels for tag grid boxes
#define BARTAB_TAGSROWS 3      // # rows in tag grid (9 tags, e.g. 3x3)
static void (*bartabmonfns[])(Monitor *) = { monocle /* , customlayoutfn */ };
static void (*bartabfloatfns[])(Monitor *) = { NULL /* , customlayoutfn */ };

static const float facts[1];    //static const float facts[]     = {     0,     0.5 }; // = mfact   // 50%
static const int masters[1];    //static const int masters[]     = {     0,      -1 }; // = nmaster // vertical stacking (for rotated monitor)
static const int views[1];      //static const int views[]       = {     0,      ~0 }; // = nviews  // all tags
/* invert tags after nviews */  /* array dimentions can both be as big as needed */  // final highlighted tags
static const int toggles[1][1]; //static const int toggles[2][2] = { {0,8}, {~0,~0} }; // 2-4+9     // all (leave as views above)
static const int toggles[1][1] = {{~0}};

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "[D]",      deck },
};

/* key definitions */
#define WINKEY Mod4Mask
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ WINKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ WINKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ WINKEY|MODKEY,                KEY,      nview,          {.ui = 1 << TAG} }, \
	{ WINKEY|MODKEY|ControlMask,    KEY,      ntoggleview,    {.ui = 1 << TAG} }, \
	{ WINKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ WINKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} }, \
  { MODKEY,                       KEY,      focusnthmon,    {.i  = TAG } }, \
  { MODKEY|ShiftMask,             KEY,      tagnthmon,      {.i  = TAG } },


/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbordercolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]  = { "st", NULL };

/*
 * Xresources preferences to load at startup
 */
ResourcePref resources[] = {
		{ "faceName",           STRING,  &font },
		{ "faceName",           STRING,  &dmenufont },
		{ "color10",        STRING,  &normbgcolor },
		{ "color11",    STRING,  &normbordercolor },
		{ "color7",        STRING,  &normfgcolor },
		{ "color11",     STRING,  &selbgcolor },
		{ "color5",     STRING,  &selbordercolor },
		{ "foreground",         STRING,  &selfgcolor },
    { "color11",       STRING,  &warnbggcolor },
    { "color9",       STRING,  &warnfggcolor },
    { "color1",         STRING,  &urgbgcolor },
    { "color0",        STRING,  &urgfggcolor },
		{ "borderpx",          	INTEGER, &borderpx },
		{ "snap",          		  INTEGER, &snap },
		{ "showbar",          	INTEGER, &showbar },
		{ "topbar",          	  INTEGER, &topbar },
		{ "nmaster",          	INTEGER, &nmaster },
		{ "resizehints",       	INTEGER, &resizehints },
		{ "mfact",      	 	    FLOAT,   &mfact },
};

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ WINKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ WINKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ WINKEY,                       XK_b,      togglebar,      {0} },
	{ WINKEY|ShiftMask,             XK_b,      toggleextrabar, {0} },
	{ WINKEY,                       XK_n,      togglefollow,   {0} },
	{ WINKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ WINKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ WINKEY|ShiftMask,             XK_j,      pushdown,       {0} },
	{ WINKEY|ShiftMask,             XK_k,      pushup,         {0} },
	{ WINKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ WINKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ WINKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ WINKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ WINKEY|ShiftMask,             XK_Return, zoom,           {0} },
	{ WINKEY,                       XK_Tab,    view,           {0} },
	{ WINKEY|ShiftMask,             XK_Tab,    swapfocus,      {0} },
	{ WINKEY,                       XK_q,      killclient,     {0} },
	{ WINKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ WINKEY|ShiftMask,             XK_f,      setlayout,      {.v = &layouts[1]} },
	{ WINKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ WINKEY,                       XK_r,      setlayout,      {.v = &layouts[3]} },
	{ WINKEY,                       XK_space,  setlayout,      {0} },
	{ WINKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ WINKEY,                       XK_f,      togglefullscr,  {0} },
	{ WINKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ WINKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ WINKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ WINKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ WINKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ WINKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
  { MODKEY|ShiftMask,             XK_a,      changefocusopacity,   {.f = +0.025}},
  { MODKEY|ShiftMask,             XK_s,      changefocusopacity,   {.f = -0.025}},
	{ MODKEY|ShiftMask,             XK_y,      changeunfocusopacity, {.f = +0.025}},
  { MODKEY|ShiftMask,             XK_x,      changeunfocusopacity, {.f = -0.025}},
	{ MODKEY,                       XK_minus,  setgaps,        {.i = -1 } },
	{ MODKEY,                       XK_equal,  setgaps,        {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_equal,  setgaps,        {.i = 0  } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ WINKEY,                       XK_grave,  reset_view,     {0} },
	{ WINKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkMonNum,            0,              Button1,        focusmon,       {.i = +1} },
	{ ClkMonNum,            0,              Button2,        reset_view,     {0} },
	{ ClkMonNum,            0,              Button3,        focusmon,       {.i = -1} },
	{ ClkFollowSymbol,      0,              Button1,        togglefollow,   {0} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkExBarLeftStatus,   0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkExBarMiddle,       0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkExBarRightStatus,  0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         WINKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         WINKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         WINKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            WINKEY|MODKEY,  Button1,        nview,          {0} },
	{ ClkTagBar,            WINKEY|MODKEY,  Button3,        ntoggleview,    {0} },
	{ ClkTagBar,            WINKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            WINKEY,         Button3,        toggletag,      {0} },
};

