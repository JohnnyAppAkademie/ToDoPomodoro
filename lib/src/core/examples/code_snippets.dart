/*
    THEME:

    /* TextTheme greifen */
    final textStyles = Theme.of(context).extension<TextThemeStyles>()!;

    /* AppStyle Farben greifen */
    final appStyle = Theme.of(context).extension<AppStyle>()!;

    /* Button-Styles greifen */
    final buttonStyles = Theme.of(context).extension<AppButtonStyles>()!;

    /* TextTheme - Größen */
    titleLarge:   50 - bold,
    titleMedium:  48,
    titleSmall:   46 - italic,

    labelLarge:   22 - bold,
    labelMedium:  20,
    labelSmall:   18 - italic,

    bodyLarge: 18 - bold,
    bodyMedium: 16,
    bodySmall: 14 - italic,

    /* Button - Typen */
    primary - Pink
    secondary - White
    card - White ( angepasst )

    PROVIDER:
    final controller = context.watch<TaskProvider>();

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

*/
