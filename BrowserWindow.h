#ifndef BrowserWindow_h
#define BrowserWindow_h

#include <QtGui/QMainWindow>

class PageWidget;
class QTabWidget;
class QUrl;
class QWKContext;

class BrowserWindow : public QMainWindow {
    Q_OBJECT

public:
    virtual ~BrowserWindow();

    static BrowserWindow* create(QWKContext* context = 0);

public slots:
    PageWidget* openInNewTab(const QString& urlFromUserInput);
    BrowserWindow* openInNewWindow(const QString& urlFromUserInput);

    PageWidget* openNewTab();
    BrowserWindow* openNewWindow();

    void closeCurrentTab();
    void jumpToNextTab();
    void jumpToPreviousTab();

private slots:
    void onCurrentTabChanged(int tabIndex);
    void onTabCloseRequested(int tabIndex);
    void onPageTitleChanged(const QString&);
    void onPageLoadingStateChanged(bool);

private:
    void setFancyWindowTitle(const QString&);
    void closePageWidget(PageWidget*);
    virtual void timerEvent(QTimerEvent*);

    BrowserWindow(QWKContext*);
    QTabWidget* m_tabs;
    QWKContext* m_context;
    int m_spinnerIndex;
    int m_spinnerTimer;
};

#endif
