#ifndef PageWidget_h
#define PageWidget_h

#include <QtGui/QWidget>

class PageGraphicsView;
class QLineEdit;
class QUrl;
class QWKContext;
class QWKPage;

class PageWidget : public QWidget {
    Q_OBJECT

public:
    PageWidget(QWKContext*, QWidget* parent = 0);
    virtual ~PageWidget();

    bool isLoading() const;

public slots:
    void load(const QUrl&);

signals:
    void titleChanged(const QString&);
    void newWindowRequested();
    void newTabRequested();
    void closeTabRequested();
    void loadingStateChanged(bool);

private slots:
    void focusLocationBar();
    void focusWebView();

    void onLoadStarted();
    void onLoadFinished(bool);
    void onLoadProgress(int);
    void onTitleChanged(const QString&);
    void onUrlChanged(const QUrl&);
    void onUrlEditReturnPressed();

private:
    QWKPage* page() const;
    friend QWKPage* newPageCallback(QWKPage*);

    QLineEdit* m_urlEdit;
    PageGraphicsView* m_view;
    bool m_loading;
};

#endif
